local machine=$1
local num_nodes=$2
local idx=$3

echo "======> setting scaling env variables for $machine ..."

docker-machine ssh $machine 'bash -s' < ./set-scaling-variables.sh $num_nodes $idx
