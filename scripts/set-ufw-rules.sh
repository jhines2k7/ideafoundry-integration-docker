#!/bin/bash

# set ufw rules for node

echo "======> setting up firewall rules for $1 ..."
docker-machine ssh $1 \
ufw allow 22/tcp \
&& ufw allow 2376/tcp \
&& ufw allow 2377/tcp \
&& ufw allow 7946/tcp \
&& ufw allow 7946/udp \
&& ufw allow 4789/udp \
&& echo "y" | ufw enable
