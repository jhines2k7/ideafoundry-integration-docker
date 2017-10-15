#!/bin/bash

echo "=======> setting env variables for manager node"

{
    printf 'export DB_HOST="%q"\n' "$1"
    printf 'export KAFKA_HOST="%q"\n' "$1"
    printf 'export ZOOKEEPER_HOST="%q"\n' "$1"
    printf 'export OKHTTP_CLIENT_TIMEOUT_SECONDS="%q"\n' "$1"
    printf 'export AIRTABLE_APP_ID="%q"\n' "$1"
    printf 'export OCCASION_EXPORT_STARTING_PAGE_NUM="%q"\n' "$1"
    printf 'export IF_OCCASION_EXPORT_URL="%q"\n' "$1"
    printf 'export IF_AIRTABLE_CREDS="%q"\n' "$1"
    printf 'export IF_DB_PASSWORD="%q"\n' "$1"
    printf 'export IF_DB_PORT="%q"\n' "$1"
    printf 'export IF_DB_ROOT_PASS=$"%q"\n' "$1"
    printf 'export IF_DB_USERNAME=$"%q"\n' "$1"
    printf 'export IF_EMAIL_CREDS=$"%q"\n' "$1"
    printf 'export IF_EMAIL_ID=$"%q"\n' "$1"
    printf 'export IF_OCCASION_CREDS=$"%q"\n' "$1"
    printf 'export GIT_USERNAME=$"%q"\n' "$1"
    printf 'export GIT_PASSWORD=$"%q"\n' "$1"
    printf 'export DOCKER_USER=$"%q"\n' "$1"
    printf 'export DOCKER_PASS=$"%q"\n' "$1"
    printf 'export DOCKER_HOST=$"%q"\n' "$1"
    printf 'export DIGITALOCEAN_ACCESS_TOKEN=$"%q"\n' "$1"
} >> /root/.profile        
