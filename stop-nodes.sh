#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql swarm-manager; 
    do docker-machine stop $i; 
done