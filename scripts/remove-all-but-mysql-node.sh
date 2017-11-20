#!/bin/bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|kafka\|512mb\|1gb\|create');
    do docker-machine rm -f $machine; 
done