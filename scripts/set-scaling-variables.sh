#!/bin/bash

{
    printf 'export NUM_NODES="%q"\n' "$1"
    printf 'export NODE_INDEX="%q"\n' "$2"
} | sudo tee -a /etc/environment > /dev/null
