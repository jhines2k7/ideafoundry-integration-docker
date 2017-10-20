#!/bin/bash

file="./failed_installs.txt"

get_ip () {
    echo $(docker-machine ip $1)
}

get_manager_machine_name () {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

get_worker_token () {
    local manager_machine=$(get_manager_machine_name)
    # gets swarm manager token for a worker node
    echo $(docker-machine ssh $manager_machine docker swarm join-token worker -q)
}

join_swarm () {
    local manager_machine=$(get_manager_machine_name)
    
    docker-machine ssh $1 \
    docker swarm join \
        --token $(get_worker_token) \
        $(get_ip $manager_machine):2377
}

copy_sql_schema () {
    echo "======> copying sql schema file to mysql node ..."

    local mysql_machine=$(docker-machine ls --format "{{.Name}}" | grep 'mysql')
    
    docker-machine ssh $mysql_machine mkdir /root/schemas
    
    docker-machine scp ../docker/data/ideafoundrybi.sql $mysql_machine:/root/schemas
}

create_node () {
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
    
    if [ ! -e "$file" ] ; then
        touch "$file"
    fi
    
    #check to make sure docker was properly installed on node
    echo "======> making sure docker is installed on $machine-$ID"
    docker-machine ssh $machine-$ID docker

    if [ $? -ne 0 ]
    then
        if [ $machine = "manager" ]
        then
            docker-machine rm -f $machine-$ID                      
            
            echo "There was an error installing docker on the manager node. The script will now exit."
            
            echo "=====> Cleaning up..."
            sh ./remove-nodes.sh
            
            exit 1
        else
            echo "There was an error installing docker on $machine-$ID."
            
            echo "$machine-$ID" >> $file
            
            return
        fi                
    fi
    
    if [ "$machine" = "mysql" ]
    then
        copy_sql_schema
    fi
 
    sh ./set-ufw-rules.sh $machine-$ID
    
    if [ "$machine" != "manager" ]
    then
        join_swarm $machine-$ID
    fi
}

machine=$1
label=$2
size=$3
num_workers=$4

if [ $num_workers -gt 1 ]
then
    echo "======> Creating $num_workers nodes"

    for i in $(eval echo "{1..$num_workers}")
        do
            create_node $machine $label $size               
    done
else
    echo "======> Creating $num_workers node"
    create_node $machine $label $size
fi
