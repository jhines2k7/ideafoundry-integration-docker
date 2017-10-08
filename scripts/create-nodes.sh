#!/bin/bash

function create_worker_node {
    local machine=$1
    local label=$2
    local size=$3
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

    echo " ======> creating $machine-$ID node"
    docker-machine create \
        --engine-label $label \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size $size \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        $machine-$ID
}

#create createperson worker nodes
for i in {0..3};
    do 
         create_worker_node createperson-worker "node.type=createperson" 1gb
done

#create createorder worker nodes
# echo " ======> creating createorder worker nodes"
# for i in {0..3};
#     do 
#         create_worker_node createorder-worker-$i "node.type=createorder" 1gb
# done

#create createquestion worker nodes
#echo " ======> creating createquestion worker nodes"
# for i in {0..11};
#     do 
#         create_worker_node createquestion-worker-$i "node.type=createquestion" 1gb
# done

#create kafka and mysql nodes
echo " ======> creating mysql and kafka worker nodes"
for i in mysql kafka;
    do
        ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1) 
        docker-machine create \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 2gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        $i-$ID;
done

#create 1gb worker nodes
echo " ======> creating 1gb worker nodes"
for i in {0..2};
    do 
         create_worker_node 1gb-worker "node.type=1gb-worker" 1gb
done

#create manager node
ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
echo " ======> creating manager worker node"
docker-machine create \
--swarm \
--swarm-master \
--driver digitalocean \
--digitalocean-image ubuntu-17-04-x64 \
--digitalocean-size 1gb \
--digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
manager-$ID;
