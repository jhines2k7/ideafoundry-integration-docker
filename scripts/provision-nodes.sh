#!/bin/bash

function provision_swarm_manager {
    local manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')
    
    echo "=======> setting env variables for manager node"
        
    docker-machine ssh $manager_machine \
    && echo 'export DB_HOST="$DB_HOST"' >> /.profile \
    && echo 'export KAFKA_HOST="$KAFKA_HOST"' >> /.profile \
    && echo 'export ZOOKEEPER_HOST="$ZOOKEEPER_HOST"' >> /.profile \
    && echo 'export OKHTTP_CLIENT_TIMEOUT_SECONDS="$OKHTTP_CLIENT_TIMEOUT_SECONDS"' >> /.profile \
    && echo 'export AIRTABLE_APP_ID="$AIRTABLE_APP_ID"' >> /.profile \
    && echo 'export OCCASION_EXPORT_STARTING_PAGE_NUM="$OCCASION_EXPORT_STARTING_PAGE_NUM"' >> /.profile \
    && echo 'export IF_OCCASION_EXPORT_URL="$IF_OCCASION_EXPORT_URL"' >> /.profile \
    && echo 'export IF_AIRTABLE_CREDS="$IF_AIRTABLE_CREDS"' >> /.profile \
    && echo 'export IF_DB_PASSWORD="$IF_DB_PASSWORD"' >> /.profile \
    && echo 'export IF_DB_PORT="$IF_DB_PORT"' >> /.profile \
    && echo 'export IF_DB_ROOT_PASS="$IF_DB_ROOT_PASS"' >> /.profile \
    && echo 'export IF_DB_USERNAME="$IF_DB_USERNAME"' >> /.profile \
    && echo 'export IF_EMAIL_CREDS="$IF_EMAIL_CREDS"' >> /.profile \
    && echo 'export IF_EMAIL_ID="$IF_EMAIL_ID"' >> /.profile \
    && echo 'export IF_OCCASION_CREDS="$IF_OCCASION_CREDS"' >> /.profile \
    && echo 'export GIT_USERNAME="$GIT_USERNAME"' >> /.profile\
    && echo 'export GIT_PASSWORD="$GIT_PASSWORD"' >> /.profile \
    && echo 'export DOCKER_USER="$DOCKED_USER"' >> /.profile \
    && echo 'export DOCKER_PASS="$DOCKER_PASS"' >> /.profile \
    && echo 'export DOCKER_HOST="$DOCKER_HOST"' >> /.profile \
    && echo 'export DIGITALOCEAN_ACCESS_TOKEN="$DIGITALOCEAN_ACCESS_TOKEN"' >> /.profile 
}

function provision_mysql_node {
    local mysql-machine=$(docker-machine ls --format "{{.Name}}" | grep 'mysql')

    # copy the file for creating db schema to mysql node
    echo "=======> creating schema directory for mysql node"        
    docker-machine ssh $mysql-machine mkdir /schemas
    
    echo "=======> copying schema files to mysql node"
    docker-machine scp ./docker/data/ideafoundrybi.sql $mysql-machine:/schemas 
}

provision_mysql_node
provision_swarm_manager