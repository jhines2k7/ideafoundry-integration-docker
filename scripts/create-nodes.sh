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

    echo " ======> creating $machine-$ID node"
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
        join_swarm $machine-$ID
    fi
}

#create manager node
function create_manager_node {    
    create_node manager "node.type=manager" 1gb
}

#create createperson worker nodes
function create_person_worker_nodes {
    for i in {1..4};
        do 
            create_node createperson-worker "node.type=createperson" 1gb
    done    
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    echo " ======> creating 1gb worker nodes"
    
    for i in {1..1};
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

#create createorder worker nodes
# echo " ======> creating createorder worker nodes"
# for i in {0..3};
#     do 
#         create_node createorder-worker-$i "node.type=createorder" 1gb
# done

#create createquestion worker nodes
#echo " ======> creating createquestion worker nodes"
# for i in {0..11};
#     do 
#         create_node createquestion-worker-$i "node.type=createquestion" 1gb
# done

function main {
    create_manager_node
    init_swarm_manager  
    create_person_worker_nodes
    #create_1gb_worker_nodes
    #create_mysql_and_kafka_nodes
    #join_person_worker_nodes_to_swarm              
    #join_1gb_worker_nodes_to_swarm              
    #join_mysql_and_kafka_nodes_to_swarm              
}

main
