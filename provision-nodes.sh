#!/bin/bash

docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 1gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN if-swarm-manager;

for i in legacydataexport processorderemail createperson createorder createquestion mailsource;
    do docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 1gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN $i; 
done

for i in if-kafka if-mysql;
    do docker-machine create --driver digitalocean --digitalocean-image ubuntu-17-04-x64 --digitalocean-size 2gb --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN $i;
done