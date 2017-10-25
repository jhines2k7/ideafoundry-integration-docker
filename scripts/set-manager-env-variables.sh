#!/bin/bash

echo "=======> setting env variables for manager node"

{
    printf 'export DB_HOST="%q"\n' "$1"
    printf 'export KAFKA_HOST="%q"\n' "$2"
    printf 'export ZOOKEEPER_HOST="%q"\n' "$3"
    printf 'export OKHTTP_CLIENT_TIMEOUT_SECONDS="%q"\n' "$4"
    printf 'export AIRTABLE_APP_ID="%q"\n' "$5"
    printf 'export OCCASION_EXPORT_STARTING_PAGE_NUM="%q"\n' "$6"
    printf 'export IF_OCCASION_EXPORT_URL="%q"\n' "$7"
    printf 'export IF_AIRTABLE_CREDS="%q"\n' "$8"
    printf 'export IF_DB_PASSWORD="%q"\n' "$9"
    printf 'export IF_DB_PORT="%q"\n' "${10}"
    printf 'export IF_DB_ROOT_PASS="%q"\n' "${11}"
    printf 'export IF_DB_USERNAME="%q"\n' "${12}"
    printf 'export IF_EMAIL_CREDS="%q"\n' "${13}"
    printf 'export IF_EMAIL_ID="%q"\n' "${14}"
    printf 'export IF_OCCASION_CREDS="%q"\n' "${15}"
    printf 'export GIT_USERNAME="%q"\n' "${16}"
    printf 'export GIT_PASSWORD="%q"\n' "${17}"
    printf 'export DOCKER_HUB_USER="%q"\n' "${18}"
    printf 'export DOCKER_HUB_PASSWORD="%q"\n' "${19}"
    printf 'export DIGITALOCEAN_ACCESS_TOKEN="%q"\n' "${21}"
} >> /home/ubuntu/.bash_profile        
