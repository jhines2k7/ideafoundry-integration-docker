#!/usr/bin/env bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'ifmanager\|ifkafka\|if512mb\|if1gb\|saveordertodb');
    do docker-machine rm -f $machine;
done
