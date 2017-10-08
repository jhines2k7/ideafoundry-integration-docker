#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}");
    do docker-machine rm -f $machine; 
done