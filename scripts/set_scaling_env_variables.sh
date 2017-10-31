machine=$1
num_nodes=$2
idx=$3

echo "======> setting scaling env variables for $machine ..."

docker-machine ssh $machine 'bash -s' < ./set-scaling-variables.sh $num_nodes $idx
