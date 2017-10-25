#!/bin/bash

echo "=======> setting env variables for manager node"

{
    printf 'sudo export DB_HOST="%q"\n' "$1"
    printf 'sudo export KAFKA_HOST="%q"\n' "$2"
    printf 'sudo export ZOOKEEPER_HOST="%q"\n' "$3"
    printf 'sudo export OKHTTP_CLIENT_TIMEOUT_SECONDS="%q"\n' "$4"
    printf 'sudo export AIRTABLE_APP_ID="%q"\n' "$5"
    printf 'sudo export OCCASION_EXPORT_STARTING_PAGE_NUM="%q"\n' "$6"
    printf 'sudo export IF_OCCASION_EXPORT_URL="%q"\n' "$7"
    printf 'sudo export IF_AIRTABLE_CREDS="%q"\n' "$8"
    printf 'sudo export IF_DB_PASSWORD="%q"\n' "$9"
    printf 'sudo export IF_DB_PORT="%q"\n' "${10}"
    printf 'sudo export IF_DB_ROOT_PASS="%q"\n' "${11}"
    printf 'sudo export IF_DB_USERNAME="%q"\n' "${12}"
    printf 'sudo export IF_EMAIL_CREDS="%q"\n' "${13}"
    printf 'sudo export IF_EMAIL_ID="%q"\n' "${14}"
    printf 'sudo export IF_OCCASION_CREDS="%q"\n' "${15}"
    printf 'sudo export GIT_USERNAME="%q"\n' "${16}"
    printf 'sudo export GIT_PASSWORD="%q"\n' "${17}"
    printf 'sudo export DOCKER_HUB_USER="%q"\n' "${18}"
    printf 'sudo export DOCKER_HUB_PASSWORD="%q"\n' "${19}"
    printf 'sudo export DIGITALOCEAN_ACCESS_TOKEN="%q"\n' "${21}"
} >> /etc/environment        
