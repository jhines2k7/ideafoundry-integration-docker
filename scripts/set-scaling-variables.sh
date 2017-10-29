#!/bin/bash

{
    printf 'NUM_NODES="%q"\n' "$1"
    printf 'NODE_INDEX="%q"\n' "$2"
} | sudo tee -a /etc/environment > /dev/null
