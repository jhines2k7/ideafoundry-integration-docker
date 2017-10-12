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
 
    sh ./set-ufw-rules.sh $machine-$ID
    
    if [ $machine != "manager" ]
    then
        #join_swarm $machine-$ID
        echo "will join swarm here"
    fi
}

#create manager node
function create_manager_node {    
    create_node manager "node.type=manager" 1gb
}

#create createperson worker nodes
function create_person_worker_nodes {
    local num_nodes=$1

    for i in $(eval echo "{1..$num_nodes}")
        do 
            create_node createperson-worker "node.type=createperson" 1gb            
    done

    set_scaling_env_variables createperson $num_nodes
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    local num_nodes=$1

    echo " ======> creating 1gb worker nodes"
    
    for i in $(eval echo "{1..$num_nodes}")
        do 
            create_node 1gb-worker "node.type=1gb-worker" 1gb
    done
}

#create kafka and mysql nodes
function create_mysql_and_kafka_nodes {
    echo " ======> creating mysql and kafka worker nodes"
    
    for i in mysql kafka;
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

    docker-machine ssh $manager_machine git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com:jhines2k7/ideafoundry-integration-docker.git
    
    docker-machine ssh $manager_machine \
    && docker login --username=$DOCKER_USER --password=$DOCKER_PASS \
    && cd ideafoundry-integration-docker \
    && docker stack deploy --compose-file docker-compose.yml --with-registry-auth integration    
}

function set_scaling_env_variables {
    local machine_type=$1
    local num_nodes=$2
    local index=0

    for machine in $(docker-machine ls --format "{{.Name}}" | grep $machine_type)
        do
            echo "======> setting scaling env variables for $machine ..."

            docker-machine ssh $machine 'bash -s' < set-scaling-variables.sh $num_nodes $index            

            ((index++))
    done       
}

#create_manager_node
#init_swarm_manager
create_person_worker_nodes 1
#create_1gb_worker_nodes
#create_mysql_and_kafka_nodes

#bash ./provision-nodes.sh

#deploy_stack
