#!/bin/bash

#create createperson worker nodes
echo " ======> creating createperson worker nodes"
for i in {0..3};
    do 
        docker-machine create \
        --engine-label node.type=createperson \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 1gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        createperson-worker-$i; 
done

#create createorder worker nodes
echo " ======> creating createorder worker nodes"
for i in {0..3};
    do 
        docker-machine create \
        --engine-label node.type=createorder \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 1gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        createorder-worker-$i; 
done

#create createquestion worker nodes
echo " ======> creating createquestion worker nodes"
for i in {0..11};
    do 
        docker-machine create \
        --engine-label node.type=createquestion \
        --driver digitalocean --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 1gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        createoquestion-worker-$i; 
done

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
        docker-machine create \
        --engine-label node.type=1gb-worker \
        --driver digitalocean \
        --digitalocean-image ubuntu-17-04-x64 \
        --digitalocean-size 1gb \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        1gb-worker-$i; 
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