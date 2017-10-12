#!/bin/bash

echo "=======> setting env variables for manager node"
        
echo export DB_HOST="$1" >> /root/.profile
echo export KAFKA_HOST="$2" >> /root/.profile
echo export ZOOKEEPER_HOST="$3" >> /root/.profile
echo export OKHTTP_CLIENT_TIMEOUT_SECONDS="$4" >> /root/.profile
echo export AIRTABLE_APP_ID="$5" >> /root/.profile
echo export OCCASION_EXPORT_STARTING_PAGE_NUM="$6" >> /root/.profile
echo export IF_OCCASION_EXPORT_URL="$7" >> /root/.profile
echo export IF_AIRTABLE_CREDS="$8" >> /root/.profile
echo export IF_DB_PASSWORD="$9" >> /root/.profile
echo export IF_DB_PORT="${10}" >> /root/.profile
echo export IF_DB_ROOT_PASS="${11}" >> /root/.profile
echo export IF_DB_USERNAME="${12}" >> /root/.profile
echo export IF_EMAIL_CREDS="${13}" >> /root/.profile
echo export IF_EMAIL_ID="${14}" >> /root/.profile
echo export IF_OCCASION_CREDS="${15}" >> /root/.profile
echo export GIT_USERNAME="${16}" >> /root/.profile
echo export GIT_PASSWORD="${17}" >> /root/.profile
echo export DOCKER_USER="${18}" >> /root/.profile
echo export DOCKER_PASS="${19}" >> /root/.profile
echo export DOCKER_HOST="${20}" >> /root/.profile
echo export DIGITALOCEAN_ACCESS_TOKEN="${21}" >> /root/.profile
