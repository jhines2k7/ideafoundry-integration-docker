#!/bin/bash
#create 1gb worker nodes
for i in {1..20};
    do docker-machine create --engine-label node.type=1gbworker --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 1gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN 1gbworker$i; 
done

#create 2gb mysql nodes
docker-machine create --engine-label node.type=2gbworker --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN mysql; 

#create 2gb kafka node
docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN kafka;

#create manager node
docker-machine create --swarm-master --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN manager;