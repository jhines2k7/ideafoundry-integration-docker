#!/bin/bash

echo "=======> setting env variables for manager node"
        
echo "export DB_HOST=$DB_HOST" >> /root/.profile
echo "export KAFKA_HOST=$KAFKA_HOST" >> /root/.profile
echo "export ZOOKEEPER_HOST=$ZOOKEEPER_HOST" >> /root/.profile
echo "export OKHTTP_CLIENT_TIMEOUT_SECONDS=$OKHTTP_CLIENT_TIMEOUT_SECONDS" >> /root/.profile
echo "export AIRTABLE_APP_ID=$AIRTABLE_APP_ID" >> /root/.profile
echo "export OCCASION_EXPORT_STARTING_PAGE_NUM=$OCCASION_EXPORT_STARTING_PAGE_NUM" >> /root/.profile
echo "export IF_OCCASION_EXPORT_URL=$IF_OCCASION_EXPORT_URL" >> /root/.profile
echo "export IF_AIRTABLE_CREDS=$IF_AIRTABLE_CREDS" >> /root/.profile
echo "export IF_DB_PASSWORD=$IF_DB_PASSWORD" >> /root/.profile
echo "export IF_DB_PORT=$IF_DB_PORT" >> /root/.profile
echo "export IF_DB_ROOT_PASS=$IF_DB_ROOT_PASS" >> /root/.profile
echo "export IF_DB_USERNAME=$IF_DB_USERNAME" >> /root/.profile
echo "export IF_EMAIL_CREDS=$IF_EMAIL_CREDS" >> /root/.profile
echo "export IF_EMAIL_ID=$IF_EMAIL_ID" >> /root/.profile
echo "export IF_OCCASION_CREDS=$IF_OCCASION_CREDS" >> /root/.profile
echo "export GIT_USERNAME=$GIT_USERNAME" >> /root/.profile
echo "export GIT_PASSWORD=$GIT_PASSWORD" >> /root/.profile
echo "export DOCKER_USER=$DOCKED_USER" >> /root/.profile
echo "export DOCKER_PASS=$DOCKER_PASS" >> /root/.profile
echo "export DOCKER_HOST=$DOCKER_HOST" >> /root/.profile
echo "export DIGITALOCEAN_ACCESS_TOKEN=$DIGITALOCEAN_ACCESS_TOKEN" >> /root/.profile
