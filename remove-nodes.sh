#!/bin/bash

for i in legacydataexport processorderemail createperson createorder createquestion mailsource kafka mysql; 
    do docker-machine rm -f $i; 
done