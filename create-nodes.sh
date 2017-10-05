#!/bin/bash
#create 1gb worker nodes
for i in {1..20};
    do docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 1gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN 1gbworker$i; 
done

#create 2gb worker nodes
docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN 2gbworker; 

#create manager node
docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN manager;