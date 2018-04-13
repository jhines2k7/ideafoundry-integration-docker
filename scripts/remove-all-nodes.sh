#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'if_manager\|if_kafka\|if_512mb\|if_1gb\|saveordertodb\|if_mysql');
    do docker-machine rm -f $machine;
done