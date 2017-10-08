#!/bin/bash

function get_worker_token {
  # gets swarm manager token for a worker node
  echo $(docker-machine ssh manager docker swarm join-token worker -q)
}

function getIP {
  echo $(docker-machine ip $1)
}

function initSwarmManager {
  # initialize swarm mode and create a manager
  echo '============================================'
  echo "======> Initializing first swarm manager ..."
  docker-machine ssh manager \
  docker swarm init \
    --advertise-addr $(getIP manager)
}

function join_node_swarm {
    local node=$1
    echo "======> $node joining swarm as worker ..."
    docker-machine ssh $node \
    docker swarm join \
        --token $(get_worker_token) $(getIP manager):2377 \
    && systemctl restart docker
}

# set ufw rules for node
function set_ufw_rules {
    local node=$1

    echo "======> setting up firewall rules for $node ..."
    docker-machine ssh $node \
    ufw allow 22/tcp \
    && ufw allow 2376/tcp \
    && ufw allow 2377/tcp \
    && ufw allow 7946/tcp \
    && ufw allow 7946/udp \
    && ufw allow 4789/udp \
    && echo "y" | ufw enable
}

#set ufw rules for manager node
set_ufw_rules manager

echo "======> Initializing swarm manager ..."
initSwarmManager

# =========================================
# Begin createperson worker nodes setup
echo "======> setting env variables for createperson nodes ..."
#set env variables for createperson nodes
index=0
for i in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do 
        echo "======> setting up env variables for $i ..." 
        docker-machine ssh $i \
        export CREATE_PERSON_NODES=4 \
        && export CREATE_PERSON_NODE_INDEX=$index \
        && echo "Value of CREATE_PERSON_NODES: " \
        && echo $CREATE_PERSON_NODES \
        && echo "Value of CREATE_PERSON_NODE_INDEX: "  \
        && echo $CREATE_PERSON_NODE_INDEX

        ((index++))
done

# set ufw rules for createperson nodes
for i in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do
        set_ufw_rules $i
done

#join createperson worker nodes to swarm
for i in $(docker-machine ls --format "{{.Name}}" | grep createperson);
    do
        join_node_swarm $i        
done
# End createperson worker nodes setup
# =========================================

# =========================================
# Begin 1gb worker nodes setup

# set ufw rules for 1gb worker nodes
for i in $(docker-machine ls --format "{{.Name}}" | grep 1gb-worker);
    do
        set_ufw_rules $i        
done

#join 1gb worker nodes to swarm
for i in $(docker-machine ls --format "{{.Name}}" | grep 1gb-worker);
    do
        join_node_swarm 1gb-worker-$i
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