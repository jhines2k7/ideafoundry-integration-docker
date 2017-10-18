#!/bin/bash

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

function get_worker_token {
    local manager_machine=$(get_manager_machine_name)
    # gets swarm manager token for a worker node
    echo $(docker-machine ssh $manager_machine docker swarm join-token worker -q)
}

function join_swarm {
    local manager_machine=$(get_manager_machine_name)
    
    docker-machine ssh $1 \
    docker swarm join \
        --token $(get_worker_token) \
        $(get_ip $manager_machine):2377
}

function create_node {
    local machine=$1
    local label=$2
    local size=$3
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
    
    echo "======> creating $machine-$ID node"
    
    docker-machine create \
    --engine-label $label \
    --driver digitalocean \
    --digitalocean-image ubuntu-17-04-x64 \
    --digitalocean-size $size \
    --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    $machine-$ID
        
    if [ $machine == "manager" ] && [ $? -ne 0 ]
    then
        echo "There was an error creating the manager node. The script will now exit. Please try again."
        set -e
    fi
 
    sh ./set-ufw-rules.sh $machine-$ID
    
    if [ $machine != "manager" ]
    then
        join_swarm $machine-$ID
    fi
}

#create manager node
function create_manager_node {    
    create_node manager "node.type=manager" 1gb
    
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

    for i in $(eval echo "{1..$num_nodes}")
        do 
            create_node createperson-worker "node.type=createperson" 1gb            
    done

    set_scaling_env_variables createperson 50
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 1gb worker nodes"
    
    for i in $(eval echo "{1..$num_nodes}")
        do 
            create_node 1gb-worker "node.type=1gb-worker" 1gb
    done
}

#create kafka and mysql nodes
function create_mysql_and_kafka_nodes {
    echo "======> creating mysql and kafka worker nodes"
    
    #for i in mysql kafka;
    for i in kafka;
        do
            create_node $i "node.type=$i" 2gb
    done
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
    
    docker-machine ssh $manager_machine docker login --username=$DOCKER_USER --password=$DOCKER_PASS
    
    docker-machine ssh $manager_machine \
        docker stack deploy \
            --compose-file docker-compose.yml \
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
    echo "======> copying compose file to manager node ..."

    local mysql_machine=$(docker-machine ls --format "{{.Name}}" | grep 'mysql')
    
    docker-machine ssh $mysql_machine mkdir /schemas
    
    docker-machine scp ./docker/data/ideafoundrybi.sql $mysql_machine:/schemas
}

function copy_compose_file {
    echo "======> copying compose file to manager node ..."
            
    docker-machine scp ../docker-compose.yml $(get_manager_machine_name):/root
}

create_manager_node
init_swarm_manager
copy_compose_file
#create_person_worker_nodes 4
#create_1gb_worker_nodes 1
create_mysql_and_kafka_nodes
#copy_sql_schema
deploy_stack
