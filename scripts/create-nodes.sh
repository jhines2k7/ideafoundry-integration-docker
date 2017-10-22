#!/bin/bash

file="./failed_installs.txt"

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

#create manager node
function create_manager_node {    
    bash ./create-node.sh manager "node.type=manager" 1gb 1
}

function set_manager_node_env_variables {
    ./runremote.sh \
       ./set-manager-env-variables.sh \
       $(get_manager_machine_name)  \
       "$DB_HOST" \
       "$KAFKA_HOST" \
       "$ZOOKEEPER_HOST" \
       "$OKHTTP_CLIENT_TIMEOUT_SECONDS" \
       "$AIRTABLE_APP_ID" \
       "$OCCASION_EXPORT_STARTING_PAGE_NUM" \
       "$IF_OCCASION_EXPORT_URL" \
       "$IF_AIRTABLE_CREDS" \
       "$IF_DB_PASSWORD" \
       "$IF_DB_PORT" \
       "$IF_DB_ROOT_PASS" \
       "$IF_DB_USERNAME" \
       "$IF_EMAIL_CREDS" \
       "$IF_EMAIL_ID" \
       "$IF_OCCASION_CREDS" \
       "$GIT_USERNAME" \
       "$GIT_PASSWORD" \
       "$DOCKER_HUB_USER" \
       "$DOCKER_HUB_PASSWORD" \
       "$DIGITALOCEAN_ACCESS_TOKEN"
}

#create createperson worker nodes
function create_person_worker_nodes {
    local num_nodes=$1

    bash ./create-node.sh createperson "node.type=createperson" 1gb $num_nodes

    set_scaling_env_variables createperson 50
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 1gb worker nodes"
    
    bash ./create-node.sh 1gb-worker "node.type=1gb-worker" 1gb $num_nodes
}

#create kafka and mysql nodes
function create_mysql_and_kafka_nodes {
    echo "======> creating mysql and kafka worker nodes"
    
    bash ./create-node.sh mysql "node.type=mysql" 2gb 1
    
    bash ./create-node.sh kafka "node.type=kafka" 2gb 1
}

function init_swarm_manager {
    # initialize swarm mode and create a manager
    echo "======> Initializing swarm manager ..."
    
    local manager_machine=$(get_manager_machine_name)
    local ip=$(docker-machine ip $manager_machine)

    echo "Swarm manager machine name: $manager_machine"
    docker-machine ssh $manager_machine docker swarm init --advertise-addr $ip
}       

function deploy_stack {
    local manager_machine=$(get_manager_machine_name)
        
    docker-machine ssh $manager_machine docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD
    
    docker-machine ssh $manager_machine docker stack deploy \
            --compose-file docker-compose.dev.yml \
            --with-registry-auth \
            integration
}

function set_scaling_env_variables {
    local machine_type=$1
    local num_nodes=$2
    local index=0

    for machine in $(docker-machine ls --format "{{.Name}}" | grep $machine_type)
        do
            echo "======> setting scaling env variables for $machine ..."

            docker-machine ssh $machine 'bash -s' < ./set-scaling-variables.sh $num_nodes $index            

            ((index++))
    done       
}

function copy_sql_schema {
    echo "======> copying sql schema file to mysql node ..."

    local mysql_machine=$(docker-machine ls --format "{{.Name}}" | grep 'mysql')
    
    docker-machine ssh $mysql_machine mkdir /root/schemas
    
    docker-machine scp ../docker/data/ideafoundrybi.sql $mysql_machine:/root/schemas
}

function copy_compose_file {
    echo "======> copying compose file to manager node ..."
            
    docker-machine scp ../docker-compose.dev.yml $(get_manager_machine_name):/root
}

function create_512mb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 512mb worker nodes"
    
    bash ./create-node.sh 512mb-worker "node.type=512mb-worker" 512mb $num_nodes
}

> $file

create_manager_node
init_swarm_manager
set_manager_node_env_variables
copy_compose_file
#create_person_worker_nodes 8
create_1gb_worker_nodes 1
create_512mb_worker_nodes 1
create_mysql_and_kafka_nodes

bash ./remove-nodes-with-failed-docker-installations.sh 

deploy_stack
