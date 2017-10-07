#!/bin/bash
#create createperson worker nodes
for i in {1..4};
    do docker-machine create \
    --engine-label node.type=createperson \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size 1gb \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    createperson-worker-$i; 
done

#create createorder worker nodes
for i in {1..4};
    do docker-machine create \
    --engine-label node.type=createorder \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size 1gb \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    createorder-worker-$i; 
done

#create createquestion worker nodes
for i in {1..12};
    do docker-machine create \
    --engine-label node.type=createquestion \
    --driver digitalocean --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size 1gb \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    createoquestion-worker-$i; 
done

#create kafka and mysql nodes
for i in mysql kafka;
    do docker-machine create \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size 2gb \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    $i;
done

#create 1gb worker nodes
for i in {1..3};
    do docker-machine create \
    --engine-label node.type=1gb-worker \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size 1gb \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    1gb-worker-$i; 
done

#create manager node
docker-machine create \
--swarm-master \
--driver digitalocean \
--digitalocean-image ubuntu-17-04-x64 \
--digitalocean-size 1gb \
--digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
manager;