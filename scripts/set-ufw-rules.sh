#!/usr/bin/expect

# set ufw rules for node

echo "======> setting up firewall rules for $1 ..."

docker-machine ssh $1 \
echo '"y" | ufw --force enable \
&& ufw default deny incoming \
&& ufw allow 9418/tcp \
&& ufw allow 22/tcp \
&& ufw allow 2376/tcp \
&& ufw allow 2377/tcp \
&& ufw allow 7946/tcp \
&& ufw allow 7946/udp \
&& ufw allow 4789/udp \
&& ufw reload \
&& systemctl restart docker'
