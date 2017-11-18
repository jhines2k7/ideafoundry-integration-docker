#!/bin/bash

echo "=======> setting env variables for manager node"

{
    printf 'DB_HOST="%q"\n' "$1"
    printf 'KAFKA_HOST="%q"\n' "$2"
    printf 'ZOOKEEPER_HOST="%q"\n' "$3"
    printf 'OKHTTP_CLIENT_TIMEOUT_SECONDS="%q"\n' "$4"
    printf 'AIRTABLE_APP_ID="%q"\n' "$5"
    printf 'OCCASION_EXPORT_STARTING_PAGE_NUM="%q"\n' "$6"
    printf 'IF_OCCASION_EXPORT_URL="%q"\n' "$7"
    printf 'IF_AIRTABLE_CREDS="%q"\n' "$8"
    printf 'IF_DB_PASSWORD="%q"\n' "$9"
    printf 'IF_DB_PORT="%q"\n' "${10}"
    printf 'IF_DB_ROOT_PASS="%q"\n' "${11}"
    printf 'IF_DB_USERNAME="%q"\n' "${12}"
    printf 'IF_EMAIL_CREDS="%q"\n' "${13}"
    printf 'IF_EMAIL_ID="%q"\n' "${14}"
    printf 'IF_OCCASION_CREDS="%q"\n' "${15}"
    printf 'GIT_USERNAME="%q"\n' "${16}"
    printf 'GIT_PASSWORD="%q"\n' "${17}"
    printf 'DOCKER_HUB_USER="%q"\n' "${18}"
    printf 'DOCKER_HUB_PASSWORD="%q"\n' "${19}"
    printf 'DIGITALOCEAN_ACCESS_TOKEN="%q"\n' "${20}"
    printf 'INSTANCE_COUNT="%q"\n' "${21}"
} | sudo tee -a /etc/environment > /dev/null
