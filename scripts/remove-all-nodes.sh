#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'ifmanager\|ifkafka\|if512mb\|if1gb\|saveordertodb\|ifmysql');
    do docker-machine rm -f $machine;
done