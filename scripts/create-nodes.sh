#!/bin/bash

file="./failed_installs.txt"

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

#create manager node
function create_manager_node {    
    sh ./create-node.sh manager "node.type=manager" 1gb 1
    
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
       "$DOCKER_USER" \
       "$DOCKER_PASS" \
       "$DOCKER_HOST" \
       "$DIGITALOCEAN_ACCESS_TOKEN"
}

#create createperson worker nodes
function create_person_worker_nodes {
    local num_nodes=$1

    sh ./create-node.sh createperson "node.type=createperson" 1gb num_nodes

    set_scaling_env_variables createperson 50
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 1gb worker nodes"
    
    sh ./create-node.sh 1gb-worker "node.type=1gb-worker" 1gb num_nodes
}

#create kafka and mysql nodes
function create_mysql_and_kafka_nodes {
    echo "======> creating mysql and kafka worker nodes"
    
    sh ./create-node.sh mysql "node.type=mysql" 2gb 1
    
    sh ./create-node.sh mysql "node.type=kafka" 2gb 1
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
        
    docker-machine ssh $manager_machine \
        docker login --username=$DOCKER_USER --password=$DOCKER_PASS \
        && docker stack deploy \
            --compose-file ./docker-compose.yml \
            --with-registry-auth integration
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
            
    docker-machine scp ../docker-compose.yml $(get_manager_machine_name):/root
}

function remove_nodes_with_failed_docker_installations {
    if [[ -s $file ]] ; then
        echo "======> removing machines with failed docker installations ..."
    
        while read machine || [[ -n $machine ]] ; do
            docker-machine rm -f $machine
        done < $file
    else
        echo "======> there were no machines with failed docker installations ..."
    fi ;
}

> $file

create_manager_node
init_swarm_manager
copy_compose_file
#create_person_worker_nodes 8
#create_1gb_worker_nodes 1
create_mysql_and_kafka_nodes
copy_sql_schema
remove_nodes_with_failed_docker_installations
deploy_stack
