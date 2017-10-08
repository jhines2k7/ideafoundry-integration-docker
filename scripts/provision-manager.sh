#!/bin/bash

# initialize swarm mode and create a manager
echo '============================================'
echo "======> Initializing swarm manager ..."
docker swarm init \
   --advertise-addr $(/sbin/ip route|awk '/default/ { print $3 }')

echo "Cloning repo" 
git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/jhines2k7/ideafoundry-integration-docker.git 
cd ./ideafoundry-integration-docker 
echo "Setting docker credentials" 
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
echo "Deploying stack"
docker stack deploy --compose-file docker-compose.yml --with-registry-auth integration

