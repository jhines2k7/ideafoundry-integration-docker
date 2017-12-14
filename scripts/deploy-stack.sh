#!/usr/bin/env bash

ENV=$1
PROVIDER=$2

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

docker_file="docker-compose.yml"
directory=/

if [ "$PROVIDER" = "aws" ]
then
    docker_file="docker-compose.aws.yml"
    directory=/home/ubuntu/
fi

if [ "$ENV" = "dev" ]
then
    docker_file="docker-compose.dev.yml"
fi

if [ "$ENV" = "test" ]
then
    docker_file="docker-compose.dev.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file $directory$docker_file \
    --with-registry-auth \
    integration