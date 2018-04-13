#!/usr/bin/env bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'if_manager\|if_kafka\|if_512mb\|if_1gb\|saveordertodb');
    do docker-machine rm -f $machine;
done
