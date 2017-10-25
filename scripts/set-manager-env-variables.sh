#!/bin/bash

echo "=======> setting env variables for manager node"

echo "sudo export DB_HOST=$1" >> /etc/environment
echo "sudo export KAFKA_HOST=$2" >> /etc/environment
echo "sudo export ZOOKEEPER_HOST=$3" >> /etc/environment
echo "sudo export OKHTTP_CLIENT_TIMEOUT_SECONDS=$4" >> /etc/environment
echo "sudo export AIRTABLE_APP_ID=$5" >> /etc/environment
echo "sudo export OCCASION_EXPORT_STARTING_PAGE_NUM=$6" >> /etc/environment
echo "sudo export IF_OCCASION_EXPORT_URL=$7" >> /etc/environment
echo "sudo export IF_AIRTABLE_CREDS=$8" >> /etc/environment
echo "sudo export IF_DB_PASSWORD=$9" >> /etc/environment
echo "sudo export IF_DB_PORT=${10}" >> /etc/environment
echo "sudo export IF_DB_ROOT_PASS=${11}" >> /etc/environment
echo "sudo export IF_DB_USERNAME=${12}" >> /etc/environment
echo "sudo export IF_EMAIL_CREDS=${13}" >> /etc/environment
echo "sudo export IF_EMAIL_ID=${14}" >> /etc/environment
echo "sudo export IF_OCCASION_CREDS=${15}" >> /etc/environment
echo "sudo export GIT_USERNAME=${16}" >> /etc/environment
echo "sudo export GIT_PASSWORD=${17}" >> /etc/environment
echo "sudo export DOCKER_HUB_USER=${18}" >> /etc/environment
echo "sudo export DOCKER_HUB_PASSWORD=${19}" >> /etc/environment
echo "sudo export DIGITALOCEAN_ACCESS_TOKEN=${21}" >> /etc/environment       
