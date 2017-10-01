#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql if-swarm-manager; 
    do docker-machine start $i; 
done