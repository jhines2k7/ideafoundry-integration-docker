#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource if-kafka if-mysql; 
    do docker-machine stop $i; 
done