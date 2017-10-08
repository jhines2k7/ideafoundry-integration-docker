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
    --token $(get_worker_token) \
    $(getIP manager):2377 \
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
for i in {0..3};
    do 
        echo "======> setting up env variables for createperson-worker-$i ..." 
        docker-machine ssh createperson-worker-$i \
        export CREATE_PERSON_NODES=4 \
        && export CREATE_PERSON_NODE_INDEX=$i 
done

# set ufw rules for createperson nodes
for i in {0..3};
    do
        set_ufw_rules createperson-worker-$i
done

#join createperson worker nodes to swarm
for i in {0..3};
    do
        join_node_swarm createperson-worker-$i        
done
# End createperson worker nodes setup
# =========================================

# =========================================
# Begin 1gb worker nodes setup

# set ufw rules for 1gb worker nodes
for i in {0..2};
    do
        set_ufw_rules 1gb-worker-$i        
done

#join 1gb worker nodes to swarm
for i in {0..2};
    do
        join_node_swarm 1gb-worker-$i
done
# End 1gb worker nodes setup
# =========================================

# =========================================
# Begin mysql and kafka nodes setup

# set ufw rules for mysql and kafka worker nodes
for i in mysql kafka;
    do
        set_ufw_rules $i        
done

# join mysql and kafka worker nodes to swarm
for i in mysql kafka;
    do
        join_node_swarm $i        
done

# copy the file for creating db schema to mysql node
echo "=======> creating schema directory for mysql node"
docker-machine ssh mysql \
mkdir /schemas
echo "=======> copying schema files to mysql node"
docker-machine scp ./docker/data/ideafoundrybi.sql mysql:/schemas 

# End 1gb mysql and kafka nodes setup
# =========================================