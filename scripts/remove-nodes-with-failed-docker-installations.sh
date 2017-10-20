#!/bin/bash

file="./failed_installs.txt"

if [[ -s $file ]] ; then
    echo "======> removing machines with failed docker installations ..."

    while read machine || [[ -n $machine ]] ; do
        docker-machine rm -f $machine
    done < $file
else
    echo "======> there were no machines with failed docker installations ..."
fi ;

> $file
