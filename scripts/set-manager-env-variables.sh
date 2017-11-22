#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo "DB_HOST=$1"
    echo "KAFKA_HOST=$2"
    echo "ZOOKEEPER_HOST=$3"
    echo "OKHTTP_CLIENT_TIMEOUT_SECONDS=$4"
    echo "AIRTABLE_APP_ID=$5"
    echo "OCCASION_EXPORT_STARTING_PAGE_NUM=$6"
    echo "IF_OCCASION_EXPORT_URL=$7"
    echo "IF_AIRTABLE_CREDS=$8"
    echo "IF_DB_PASSWORD=$9"
    echo "IF_DB_PORT=${10}"
    echo "IF_DB_ROOT_PASS=${11}"
    echo "IF_DB_USERNAME=${12}"
    echo "IF_EMAIL_CREDS=${13}"
    echo "IF_EMAIL_ID=${14}"
    echo "IF_OCCASION_CREDS=${15}"
    echo "GIT_USERNAME=${16}"
    echo "GIT_PASSWORD=${17}"
    echo "DOCKER_HUB_USER=${18}"
    echo "DOCKER_HUB_PASSWORD=${19}"
    echo "DIGITALOCEAN_ACCESS_TOKEN=${20}"
    echo "MAX_CREATEPERSON_INSTANCE_COUNT=${21}"
} | sudo tee -a /etc/environment > /dev/null
