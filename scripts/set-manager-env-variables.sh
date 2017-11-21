#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo 'DB_HOST="$1"\n'
    echo 'KAFKA_HOST="$2"\n'
    echo 'ZOOKEEPER_HOST="$3"\n'
    echo 'OKHTTP_CLIENT_TIMEOUT_SECONDS="$4"\n'
    echo 'AIRTABLE_APP_ID="$5"\n'
    echo 'OCCASION_EXPORT_STARTING_PAGE_NUM="$6"\n'
    echo 'IF_OCCASION_EXPORT_URL="$7"\n'
    echo 'IF_AIRTABLE_CREDS="$8"\n'
    echo 'IF_DB_PASSWORD="$9"\n'
    echo 'IF_DB_PORT="${10}"\n'
    echo 'IF_DB_ROOT_PASS="${11}"\n'
    echo 'IF_DB_USERNAME="${12}"\n'
    echo 'IF_EMAIL_CREDS="${13}"\n'
    echo 'IF_EMAIL_ID="${14}"\n'
    echo 'IF_OCCASION_CREDS="${15}"\n'
    echo 'GIT_USERNAME="${16}"\n'
    echo 'GIT_PASSWORD="${17}"\n'
    echo 'DOCKER_HUB_USER="${18}"\n'
    echo 'DOCKER_HUB_PASSWORD="${19}"\n'
    echo 'DIGITALOCEAN_ACCESS_TOKEN="${20}"\n'
    echo 'INSTANCE_COUNT="${21}"\n'
} | sudo tee -a /etc/environment > /dev/null
