#!/bin/bash

failed_installs_file="./failed_installs.txt"

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

#create manager node
function create_manager_node {
    bash ./create-node.sh manager 1 $ENV $PROVIDER

    result=$?

    if [ $result -ne 0 ]
    then
        echo "There was an error installing docker on the manager node. The script will now exit."
        
        echo "=====> Cleaning up..."

        bash ./remove-all-nodes.sh

        exit 1   
    fi
}

function set_manager_node_env_variables {
    local kafka_host="kafka"
    local zookeeper_host="zookeeper"
    local mysql_host="mysql"

    if [ "$ENV" = "dev" ]
    then
        kafka_machine_ip=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'kafka'))
        mysql_host=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'mysql'))

        kafka_host=$kafka_machine_ip
        zookeeper_host=$kafka_machine_ip
    fi

    ./runremote.sh \
       ./set-manager-env-variables.sh \
       $(get_manager_machine_name)  \
       "$mysql_host" \
       "$kafka_host" \
       "$zookeeper_host" \
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
       "$DIGITALOCEAN_ACCESS_TOKEN" \
       "$MAX_CREATEPERSON_INSTANCE_COUNT" \
       "$RECONCILE" \
       "$INSTANCE_COUNT" \
       "$UNPROCESSED_ORDER_IDS_FILE" \
       "$ENV" \
       "$PERSONSINK_REPLICAS"
}

#create createperson worker nodes
function create_person_worker_nodes {
    local num_nodes=$1

    bash ./create-node.sh createperson $num_nodes $ENV $PROVIDER
}

#create 1gb worker nodes
function create_1gb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 1gb worker nodes"
    
    bash ./create-node.sh 1gb $num_nodes $ENV $PROVIDER
}

#create kafka and mysql nodes
function create_kafka_node {
    echo "======> creating kafka worker node"

    bash ./create-node.sh kafka 1 $ENV $PROVIDER

    result=$?

    if [ $result -ne 0 ]
    then
        exit 1
    fi
}
 
function create_mysql_node {
    echo "======> creating mysql worker node"
    
    bash ./create-node.sh mysql 1 $ENV $PROVIDER

    result=$?

    if [ $result -ne 0 ]
    then
        exit 1
    fi
}

function init_swarm_manager {
    # initialize swarm mode and create a manager
    echo "======> Initializing swarm manager ..."
    
    local manager_machine=$(get_manager_machine_name)
    local ip=$(docker-machine ip $manager_machine)

    echo "Swarm manager machine name: $manager_machine"
    docker-machine ssh $manager_machine sudo docker swarm init --advertise-addr $ip
}

function copy_compose_file {
    local docker_file="../docker-compose.yml"
    local directory=/

    if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "dev" ]
    then
        directory=/home/ubuntu
        docker_file="../docker-compose.aws.dev.yml"
    fi

    if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "test" ]
    then
        directory=/home/ubuntu
        docker_file="../docker-compose.aws.test.yml"
    fi

    if [ "$PROVIDER" != "aws" ] && [ "$ENV" = "staging" ]
    then
        docker_file="../docker-compose.staging.yml"
    fi

    if [ "$PROVIDER" != "aws" ] && [ "$ENV" = "dev" ]
    then
        docker_file="../docker-compose.dev.yml"
    fi

    echo "======> copying compose file to manager node ..."
    
    docker-machine scp $docker_file $(get_manager_machine_name):$directory
}

function create_512mb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 512mb worker nodes"
    
    bash ./create-node.sh 512mb $num_nodes $ENV $PROVIDER
}

> $failed_installs_file

if [ "$RECONCILE" = true ]
then
    bash ./remove-all-but-mysql-node.sh
else
    bash ./remove-all-nodes.sh
fi

create_manager_node
init_swarm_manager
copy_compose_file

if [ "$RECONCILE" = false ]
then
    echo "======> creating kafka and mysql nodes ..."

    create_kafka_node &
    create_mysql_node &

    wait %1
    create_kafka_result=$?

    wait %2
    create_mysql_result=$?

    if [ $create_kafka_result -ne 0 ] || [ $create_mysql_result -ne 0 ]
    then
        echo "There was an error installing docker on the mysql or kafka node. The script will now exit."

        echo "=====> Cleaning up..."

        bash ./remove-all-nodes.sh

        exit 1
    fi
else
    echo "======> creating kafka node ..."

    create_kafka_node &
    wait %1
    create_kafka_result=$?

    if [ $create_kafka_result -ne 0 ]
    then
        echo "There was an error installing docker on the kafka node. The script will now exit."

        echo "=====> Cleaning up..."

        bash ./remove-all-nodes.sh

        exit 1
    fi
fi
echo "======> finished creating kafka and mysql nodes ..."

echo "======> creating worker nodes ..."
create_person_worker_nodes $INSTANCE_COUNT &
create_1gb_worker_nodes 1 &
if [ "$ENV" = "dev" ] || [ "$ENV" = "test" ]
then
    create_512mb_worker_nodes 1 &
fi
wait
echo "======> finished creating worker nodes ..."

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

docker-machine ls
