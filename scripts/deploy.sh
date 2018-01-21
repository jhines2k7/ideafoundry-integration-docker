#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

docker_file="export-occasion-data-to-mysql-job.yml"
directory=/
env_file=".env"

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "dev" ]
then
    directory=/home/ubuntu/
    docker_file="export-occasion-data-to-mysql-job.dev.yml"
fi

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "test" ]
then
    directory=/home/ubuntu/
    docker_file="export-data-from-occasion-to-mysql-job.test.yml"
fi

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "staging" ]
then
    directory=/home/ubuntu/
    docker_file="docker-compose.aws.staging.yml"
fi

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "prod" ]
then
    directory=/home/ubuntu/
    docker_file="export-occasion-data-to-mysql-job.aws.yml"
fi

if [ "$PROVIDER" != "aws" ] && [ "$ENV" = "staging" ]
then
    docker_file="export-occasion-data-to-mysql-job.staging.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file $directory$docker_file \
    --with-registry-auth \
    integration
