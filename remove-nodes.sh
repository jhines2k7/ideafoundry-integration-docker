#!/bin/bash

#for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql if-swarm-manager; 
for i in legacydataexport createperson if-kafka if-mysql if-swarm-manager;
    do docker-machine rm -f $i; 
done