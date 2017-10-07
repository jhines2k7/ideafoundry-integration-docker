#!/bin/bash

# set ufw rules for manager node
echo "======> setting up firewall rules for manager ..."
docker-machine ssh manager \
ufw allow 22/tcp \
&& ufw allow 2376/tcp \
&& ufw allow 2377/tcp \
&& ufw allow 7946/tcp \
&& ufw allow 7946/udp \
&& ufw allow 4789/udp \
&& echo "y" | ufw enable

# =========================================
# Begin createperson worker nodes setup

#set env variables for createperson nodes
for i in {0..3};
    do 
        docker-machine ssh createperson-worker-$i \
        export CREATE_PERSON_NODES=4 \
        && export CREATE_PERSON_NODE_INDEX=$i 
done

# set ufw rules for createperson nodes
for node in {0..3};
    do
        echo "======> setting up firewall rules for createperson-worker-$i ..."
        docker-machine ssh createperson-worker-$i \
        ufw allow 22/tcp \
        && ufw allow 2376/tcp \
        && ufw allow 2377/tcp \
        && ufw allow 7946/tcp \
        && ufw allow 7946/udp \
        && ufw allow 4789/udp \
        && echo "y" | ufw enable
done

#join createperson worker nodes to swarm
for node in {0..3};
    do
        echo "======> createperson-worker-$i joining swarm as worker ..."
        docker-machine ssh createperson-worker-$i \
        docker swarm join \
            --token $(get_worker_token) \
            --listen-addr $(getIP createperson-worker-$i):2376 \
            --advertise-addr $(getIP createperson-worker-$i):2376 $(getIP manager):2376 \
        && systemctl restart docker
done
# End createperson worker nodes setup
# =========================================

# =========================================
# Begin 1gb worker nodes setup

# set ufw rules for 1gb worker nodes
for node in {0..2};
    do
        echo "======> setting up firewall rules for 1gb-worker-$i ..."
        docker-machine ssh 1gb-worker-$i \
        ufw allow 22/tcp \
        && ufw allow 2376/tcp \
        && ufw allow 2377/tcp \
        && ufw allow 7946/tcp \
        && ufw allow 7946/udp \
        && ufw allow 4789/udp \
        && echo "y" | ufw enable
done

#join 1gb worker nodes to swarm
for node in {0..2};
    do
        echo "======> 1gb-worker-$i joining swarm as worker ..."
        docker-machine ssh 1gb-worker-$i \
        docker swarm join \
            --token $(get_worker_token) \
            --listen-addr $(getIP 1gb-worker-$i):2376 \
            --advertise-addr $(getIP 1gb-worker-$i):2376 $(getIP manager):2376 \
        && systemctl restart docker
done
# End 1gb worker nodes setup
# =========================================

# =========================================
# Begin mysql and kafka nodes setup

# set ufw rules for mysql and kafka worker nodes
for node in mysql kafka;
    do
        echo "======> setting up firewall rules for $i ..."
        docker-machine ssh $i \
        ufw allow 22/tcp \
        && ufw allow 2376/tcp \
        && ufw allow 2377/tcp \
        && ufw allow 7946/tcp \
        && ufw allow 7946/udp \
        && ufw allow 4789/udp \
        && echo "y" | ufw enable
done

# join mysql and kafka worker nodes to swarm
for node in mysql kafka;
    do
        echo "======> $i joining swarm as worker ..."
        docker-machine ssh $i \
        docker swarm join \
            --token $(get_worker_token) \
            --listen-addr $(getIP $i):2376 \
            --advertise-addr $(getIP $i):2376 $(getIP manager):2376 \
        && systemctl restart docker
done

# copy the file for creating db schema to mysql node
echo "=======> creating schema directory for mysql node"
docker-machine ssh mysql \
mkdir /schemas
echo "=======> copying schema files to mysql node"
docker-machine scp ./docker/data/ideafoundrybi.sql mysql:/schemas 

# End 1gb mysql and kafka nodes setup
# =========================================

function get_worker_token {
  # gets swarm manager token for a worker node
  echo $(docker-machine ssh manager docker swarm join-token worker -q)
}

function getIP {
  echo $(docker-machine ip $1)
}