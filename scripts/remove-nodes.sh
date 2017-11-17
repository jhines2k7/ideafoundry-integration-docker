#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep -o 'manager\|kafka\|512mb\|1gb\|create');
    do docker-machine rm -f $machine; 
done
