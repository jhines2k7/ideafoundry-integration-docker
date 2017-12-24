#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

docker_file="docker-compose.yml"
directory=/

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "dev" ]
then
    directory=/home/ubuntu/
    docker_file="docker-compose.aws.dev.yml"
fi

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "test" ]
then
    directory=/home/ubuntu/
    docker_file="docker-compose.aws.test.yml"
fi

if [ "$PROVIDER" != "aws" ] && [ "$ENV" = "dev" ]
then
    docker_file="docker-compose.dev.yml"
fi

if [ "$PROVIDER" != "aws" ] && [ "$ENV" = "test" ]
then
    docker_file="docker-compose.test.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file $directory$docker_file \
    --with-registry-auth \
    integration