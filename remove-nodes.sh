#!/bin/bash

#remove createperson worker nodes
for i in {1..4};
    do docker-machine rm -f createperson-worker-$i; 
done

#remove createorder worker nodes
for i in {1..4};
    do docker-machine rm -f createorder-worker-$i; 
done

#remove createquestion worker nodes
for i in {1..12};
    do docker-machine rm -f createoquestion-worker-$i; 
done

#remove kafka and mysql nodes
for i in mysql kafka;
    do docker-machine rm -f $i;
done

#remove manager node
docker-machine rm -f manager;