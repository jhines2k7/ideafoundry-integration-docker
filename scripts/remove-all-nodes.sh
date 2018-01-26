#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|kafka\|512mb\|1gb\|save\|mysql');
    do docker-machine rm -f $machine;
done