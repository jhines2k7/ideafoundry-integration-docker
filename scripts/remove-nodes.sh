#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'worker\|manager\|mysql\|kafka\|512mb\|1gb\|createperson');
    do docker-machine rm -f $machine; 
done
