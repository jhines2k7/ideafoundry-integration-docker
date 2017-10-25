#!/bin/bash

echo "sudo export NUM_NODES=$1" >> /etc/environment
echo "sudo export NODE_INDEX=$2" >> /etc/environment
