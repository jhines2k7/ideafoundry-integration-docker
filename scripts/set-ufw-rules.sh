#!/bin/bash

# set ufw rules for node
function set_ufw_rules {
    local machine=$1

    echo "======> setting up firewall rules for $machine ..."
    docker-machine ssh $machine \
    ufw allow 22/tcp \
    && ufw allow 2376/tcp \
    && ufw allow 2377/tcp \
    && ufw allow 7946/tcp \
    && ufw allow 7946/udp \
    && ufw allow 4789/udp \
    && echo "y" | ufw enable
}

set_ufw_rules $1
