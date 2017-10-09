#!/bin/bash
function create_node {
    local machine=$1
    local label=$2
    local size=$3
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

    echo " ======> creating $machine-$ID node"
    docker-machine create \
    --engine-label $label \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size $size \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    $machine-$ID
    
    sh ./set-ufw-rules.sh $machine-$ID
}

local machine=$1
local label=$2
local size=$3
local num_workers=$4
local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)

if [ $num_workers -gt 1 ]
then
    echo "Creating $num_workers nodes"

    for i in $(eval echo "{1..$num_workers}")
        do
            create_node $machine $label $size               
    done
else
    echo "Creating $num_workers node"
    create_node $machine $label $size
fi
