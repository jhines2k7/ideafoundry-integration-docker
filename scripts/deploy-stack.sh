#!/bin/bash

git clone git://$GIT_USERNAME:$GIT_PASSWORD@github.com:jhines2k7/ideafoundry-integration-docker.git

docker login --username=$DOCKER_USER --password=$DOCKER_PASS

#cd ideafoundry-integration-docker

#docker stack deploy --compose-file docker-compose.yml --with-registry-auth integration
