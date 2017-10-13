#!/bin/bash

i=0
argv=()

for arg in "$@"; do
    argv[$i]="$arg"
    i=$((i + 1))
    echo "Argument $i is $arg"
done

echo "=======> setting env variables for manager node"
        
echo "export DB_HOST=${argv[0]}">> /root/.profile
echo "export KAFKA_HOST=${argv[1]}">> /root/.profile
echo "export ZOOKEEPER_HOST=${argv[2]}">> /root/.profile
echo "export OKHTTP_CLIENT_TIMEOUT_SECONDS=${argv[3]}">> /root/.profile
echo "export AIRTABLE_APP_ID=${argv[4]}">> /root/.profile
echo "export OCCASION_EXPORT_STARTING_PAGE_NUM=${argv[5]}">> /root/.profile
echo "export IF_OCCASION_EXPORT_URL=${argv[6]}">> /root/.profile
echo "export IF_AIRTABLE_CREDS=${argv[7]}">> /root/.profile
echo "export IF_DB_PASSWORD=${argv[8]}">> /root/.profile
echo "export IF_DB_PORT=${argv[9]}">> /root/.profile
echo "export IF_DB_ROOT_PASS=${argv[10]}">> /root/.profile
echo "export IF_DB_USERNAME=${argv[11]}">> /root/.profile
echo "export IF_EMAIL_CREDS=${argv[12]}">> /root/.profile
echo "export IF_EMAIL_ID=${argv[13]}">> /root/.profile
echo "export IF_OCCASION_CREDS=${argv[14]}">> /root/.profile
echo "export GIT_USERNAME=${argv[15]}">> /root/.profile
echo "export GIT_PASSWORD=${argv[16]}">> /root/.profile
echo "export DOCKER_USER=${argv[17]}">> /root/.profile
echo "export DOCKER_PASS=${argv[18]}">> /root/.profile
echo "export DOCKER_HOST=${argv[19]}">> /root/.profile
echo "export DIGITALOCEAN_ACCESS_TOKEN=${argv[20]}">> /root/.profile
