#!/bin/bash

#remove 1gb worker nodes
for i in {1..20}; 
    do docker-machine rm -f 1gbworker$i; 
done

#remove 2gb worker node

#remove mysql and kafka nodes
for i in mysql kafka; 
    do docker-machine rm -f $i;
done