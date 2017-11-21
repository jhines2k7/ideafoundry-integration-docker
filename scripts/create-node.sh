#!/bin/bash

failed_installs_file="./failed_installs.txt"
machine=$1
num_workers=$2
ENV=$3
index=0

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
    local sql_directory=/schemas

    if [ "$ENV" = "dev" ]
    then
        sql_directory=/home/ubuntu/schemas
#        sql_directory=/schemas
    fi

    docker-machine ssh $mysql_machine mkdir $sql_directory

    if [ $? -ne 0 ]
    then
        exit 1
    fi
    
    docker-machine scp ../docker/db/ideafoundry.sql $mysql_machine:$sql_directory
}

function create_node {
    local machine=$1
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
    local instance_type="t2.micro"
    local size="1gb"
    local vpc_id="vpc-cef83fa9"
    local security_group="ideafoundry-integration"
    
    echo "======> creating $machine-$ID"

    # t2.nano=0.5
    # t2.micro=1
    # t2.small=2

    case "$machine" in

    mysql)
        instance_type="t2.small"
        size="2gb"
        ;;

    kafka)
        instance_type="t2.small"
        size="2gb"
        ;;

    512mb) instance_type="t2.nano"
        ;;
    
    esac

    if [ "$ENV" = "dev" ]
    then
        security_group="ideafoundry-integration-dev"

        echo "======> launching $instance_type AWS instance..."

        docker-machine create \
        --engine-label "node.type=$machine" \
        --driver amazonec2 \
        --amazonec2-ami ami-36a8754c \
        --amazonec2-vpc-id $vpc_id \
        --amazonec2-subnet-id subnet-8d401ab0 \
        --amazonec2-security-group $security_group \
        --amazonec2-zone e \
        --amazonec2-instance-type $instance_type \
        $machine-$ID
    else
        echo "======> launching $size Digital Ocean instance..."

         docker-machine create \
         --engine-label "node.type=$machine" \
         --driver digitalocean \
         --digitalocean-image ubuntu-17-04-x64 \
         --digitalocean-size $size \
         --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
         $machine-$ID
    fi
    
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

        return 1        
    fi
    
    if [ "$machine" = "mysql" ]
    then
        copy_sql_schema

        if [ $? -ne 0 ]
        then
            exit 2
        fi
    fi
 
    bash ./set-ufw-rules.sh $machine-$ID
    
    if [ "$machine" != "manager" ]
    then
        join_swarm $machine-$ID       
    fi
}

if [ $num_workers -gt 1 ]
then
    echo "======> Creating $num_workers nodes"

    for i in $(eval echo "{1..$num_workers}")      
        do
            create_node $machine

            ((index++))                
    done
else
    echo "======> Creating $num_workers node"
    create_node $machine
fi
