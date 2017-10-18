#!/bin/bash

docker login --username=$DOCKER_USER --password=$DOCKER_PASS

docker stack deploy --compose-file docker-compose.yml --with-registry-auth integration
