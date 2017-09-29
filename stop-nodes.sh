#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource kafka mysql; 
    do docker-machine stop $i; 
done