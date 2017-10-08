#!/bin/bash

function create_worker_node {
    node=$1
    label=$2
    size=$3

    echo " ======> creating $node worker node"
    docker-machine create \
        --engine-label $label \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size $size \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        $node
}

#create createperson worker nodes
for i in {0..3};
    do 
         create_worker_node createperson-worker-$i "node.type=createperson" 1gb
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
        docker-machine create \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 2gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        $i;
done

#create 1gb worker nodes
echo " ======> creating 1gb worker nodes"
for i in {0..2};
    do 
         create_worker_node 1gb-worker-$i "node.type=1gb-worker" 1gb
done

#create manager node
echo " ======> creating manager worker nodes"
docker-machine create \
--swarm \
--swarm-master \
--driver digitalocean \
--digitalocean-image ubuntu-17-04-x64 \
--digitalocean-size 1gb \
--digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
manager;