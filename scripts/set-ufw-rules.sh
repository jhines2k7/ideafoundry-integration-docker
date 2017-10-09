#!/bin/bash

# set ufw rules for node

echo "======> setting up firewall rules for $1 ..."
docker-machine ssh $1 \
sudo ufw allow 22/tcp \
&& sudo ufw allow 2376/tcp \
&& sudo ufw allow 2377/tcp \
&& sudo ufw allow 7946/tcp \
&& sudo ufw allow 7946/udp \
&& sudo ufw allow 4789/udp \
&& echo "y" | sudo ufw enable
