local machine_type=$1
local num_nodes=$2
local starting_idx=$3

for machine in $(docker-machine ls --format "{{.Name}}" | grep $machine_type)
    do
        echo "======> setting scaling env variables for $machine ..."

        docker-machine ssh $machine 'bash -s' < ./set-scaling-variables.sh $num_nodes $starting_idx            

        ((starting_idx++))
done
