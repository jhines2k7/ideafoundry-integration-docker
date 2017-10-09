#!/bin/bash

function get_worker_token {
  # gets swarm manager token for a worker node
  local manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')
  echo $(docker-machine ssh $manager_machine docker swarm join-token worker -q)
}

function getIP {
  echo $(docker-machine ip $1)
}

function provision_swarm_manager {
    local manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')
    
    echo "=======> copying provision script to manager node"
    
    docker-machine scp ./scripts/provision-manager.sh $manager_machine:/provisioning 
    
    docker-machine ssh $manager_machine \
    && echo 'export DB_HOST="$DB_HOST"' >> /.profile \
    && echo 'export KAFKA_HOST="$KAFKA_HOST"' >> /.profile \
    && echo 'export ZOOKEEPER_HOST="$ZOOKEEPER_HOST"' >> /.profile \
    && echo 'export OKHTTP_CLIENT_TIMEOUT_SECONDS="$OKHTTP_CLIENT_TIMEOUT_SECONDS"' >> /.profile \
    && echo 'export AIRTABLE_APP_ID="$AIRTABLE_APP_ID"' >> /.profile \
    && echo 'export OCCASION_EXPORT_STARTING_PAGE_NUM="$OCCASION_EXPORT_STARTING_PAGE_NUM"' >> /.profile \
    && echo 'export IF_OCCASION_EXPORT_URL="$IF_OCCASION_EXPORT_URL"' >> /.profile \
    && echo 'export IF_AIRTABLE_CREDS="$IF_AIRTABLE_CREDS"' >> /.profile \
    && echo 'export IF_DB_PASSWORD="$IF_DB_PASSWORD"' >> /.profile \
    && echo 'export IF_DB_PORT="$IF_DB_PORT"' >> /.profile \
    && echo 'export IF_DB_ROOT_PASS="$IF_DB_ROOT_PASS"' >> /.profile \
    && echo 'export IF_DB_USERNAME="$IF_DB_USERNAME"' >> /.profile \
    && echo 'export IF_EMAIL_CREDS="$IF_EMAIL_CREDS"' >> /.profile \
    && echo 'export IF_EMAIL_ID="$IF_EMAIL_ID"' >> /.profile \
    && echo 'export IF_OCCASION_CREDS="$IF_OCCASION_CREDS"' >> /.profile \
    && echo 'export GIT_USERNAME="$GIT_USERNAME"' >> /.profile\
    && echo 'export GIT_PASSWORD="$GIT_PASSWORD"' >> /.profile \
    && echo 'export DOCKER_USER="$DOCKED_USER"' >> /.profile \
    && echo 'export DOCKER_PASS="$DOCKER_PASS"' >> /.profile \
    && echo 'export DOCKER_HOST="$DOCKER_HOST"' >> /.profile \
    && echo 'export DIGITALOCEAN_ACCESS_TOKEN="$DIGITALOCEAN_ACCESS_TOKEN"' >> /.profile \
    && sh /provisioning/provision-manager.sh
}

function join_node_swarm {
    local manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')
    local machine=$1
    echo "======> $node joining swarm as worker ..."
    docker-machine ssh $machine \
    docker swarm join \
        --token $(get_worker_token) $(getIP $manager_machine):2377 \
    && systemctl restart docker
}

# set ufw rules for node
function set_ufw_rules {
    local machine=$1

    echo "======> setting up firewall rules for $machine ..."
    docker-machine ssh $machine \
    ufw allow 22/tcp \
    && ufw allow 2376/tcp \
    && ufw allow 2377/tcp \
    && ufw allow 7946/tcp \
    && ufw allow 7946/udp \
    && ufw allow 4789/udp \
    && echo "y" | ufw enable
}

provision_swarm_manager

# =========================================
# Begin createperson worker nodes setup
echo "======> setting env variables for createperson nodes ..."
#set env variables for createperson nodes
index=0
for machine in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do 
        echo "======> setting up env variables for $machine ..." 
        docker-machine ssh $machine \
        echo "export CREATE_PERSON_NODES=4" >> /.profile \
        && echo 'export CREATE_PERSON_NODE_INDEX="$index"' >> /.profile \
        && source /.profile \
        && echo "Value of CREATE_PERSON_NODES: $CREATE_PERSON_NODES" \
        && echo "Value of CREATE_PERSON_NODE_INDEX: $CREATE_PERSON_NODE_INDEX"  \

        ((index++))
done

# set ufw rules for createperson nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do
        set_ufw_rules $machine
done

#join createperson worker nodes to swarm
for machine in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do
        join_node_swarm $machine   
done
# End createperson worker nodes setup
# =========================================

# =========================================
# Begin 1gb worker nodes setup

# set ufw rules for 1gb worker nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 1gb-worker);
    do
        set_ufw_rules $machine    
done

#join 1gb worker nodes to swarm
for machine in $(docker-machine ls --format "{{.Name}}" | grep 1gb-worker);
    do
        join_node_swarm $machine
done
# End 1gb worker nodes setup
# =========================================

# =========================================
# Begin mysql and kafka nodes setup

# set ufw rules for mysql and kafka worker nodes
mysql-machine=$(docker-machine ls --format "{{.Name}}" | grep mysql)
kafka-machine=$(docker-machine ls --format "{{.Name}}" | grep kafka)

set_ufw_rules $kafka-machine

set_ufw_rules $mysql-machine

# join mysql and kafka worker nodes to swarm
join_node_swarm $kafka-machine

join_node_swarm $mysql-machine

# copy the file for creating db schema to mysql node
echo "=======> creating schema directory for mysql node"
docker-machine ssh $mysql-machine \
mkdir /schemas
echo "=======> copying schema files to mysql node"
docker-machine scp ./docker/data/ideafoundrybi.sql $mysql-machine:/schemas 

# End 1gb mysql and kafka nodes setup
# =========================================
