#!/bin/bash

failed_installs_file="./failed_installs.txt"

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

function get_worker_token {
    local manager_machine=$(get_manager_machine_name)
    # gets swarm manager token for a worker node
    echo $(docker-machine ssh $manager_machine sudo docker swarm join-token worker -q)
}

function join_swarm {
    local manager_machine=$(get_manager_machine_name)
    
    docker-machine ssh $1 \
    sudo docker swarm join \
        --token $(get_worker_token) \
        $(get_ip $manager_machine):2377
}

function copy_sql_schema {
    echo "======> copying sql schema file to mysql node ..."

    local mysql_machine=$(docker-machine ls --format "{{.Name}}" | grep 'mysql')
    
    docker-machine ssh $mysql_machine mkdir /home/ubuntu/schemas
    
    docker-machine scp ../docker/db/ideafoundry.sql $mysql_machine:/home/ubuntu/schemas
}

function create_node {
    local machine=$1
    local label=$2
    local size=$3
    local idx=$4
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
    local instance_type="t2.micro"
    
    echo "======> creating $machine-$ID"

    # t2.nano=0.5
    # t2.micro=1
    # t2.small=2

    case "$size" in

    2gb) instance_type="t2.small"
        ;;

    512mb) instance_type="t2.nano"
        ;;
    
    esac

    docker-machine create \
    --engine-label $label \
    --driver amazonec2 \
    --amazonec2-ami ami-36a8754c \
    --amazonec2-vpc-id vpc-cef83fa9 \
    --amazonec2-subnet-id subnet-8d401ab0 \
    --amazonec2-security-group ideafoundry-integration-dev \
    --amazonec2-zone e \
    --amazonec2-instance-type $instance_type \
    $machine-$ID
    
    # docker-machine create \
    # --engine-label $label \
    # --driver digitalocean \
    # --digitalocean-image ubuntu-17-04-x64 \
    # --digitalocean-size $size \
    # --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
    # $machine-$ID
    
    if [ ! -e "$failed_installs_file" ] ; then
        touch "$failed_installs_file"
    fi
    
    #check to make sure docker was properly installed on node
    echo "======> making sure docker is installed on $machine-$ID"
    docker-machine ssh $machine-$ID docker

    if [ $? -ne 0 ]
    then
        if [ $machine = "manager" ] || [ $machine = "mysql" ] || [ $machine = "kafka" ]
        then
            exit 2
        else                                
            echo "$machine-$ID" >> $failed_installs_file
        fi

        exit 1        
    fi
    
    if [ "$machine" = "mysql" ]
    then
        copy_sql_schema
    fi
 
    bash ./set-ufw-rules.sh $machine-$ID
    
    if [ "$machine" != "manager" ]
    then
        join_swarm $machine-$ID
        
    #    if echo "$machine" | grep --quiet "create"
    #    then
    #        echo "======> Setting scaling variables for $machine-$ID"
    #
    #        bash ./set_scaling_env_variables.sh $machine-$ID $num_workers $idx
    #    fi
    fi
}

machine=$1
label=$2
size=$3
num_workers=$4
index=0

if [ $num_workers -gt 1 ]
then
    echo "======> Creating $num_workers nodes"

    for i in $(eval echo "{1..$num_workers}")      
        do
            create_node $machine $label $size $index

            if [ $? -eq 2 ]
            then
                exit 1
            fi

            ((index++))                
    done
else
    echo "======> Creating $num_workers node"
    create_node $machine $label $size
fi
