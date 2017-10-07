#!/bin/bash

#set env variables for createperson nodes
for i in {0..3};
    do 
        docker-machine ssh createperson-worker-$i \
        export CREATE_PERSON_NODES=4 \
        && export CREATE_PERSON_NODE_INDEX=$i 
done

