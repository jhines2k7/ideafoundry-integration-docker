#!/bin/bash

#for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql if-swarm-manager; 
for i in mailsource if-kafka if-mysql if-swarm-manager; 
    do docker-machine rm -f $i; 
done