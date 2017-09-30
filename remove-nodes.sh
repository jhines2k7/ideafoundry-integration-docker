#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql; 
    do docker-machine rm -f $i; 
done