#!/bin/bash
for line in $(cat uid.txt)  
do  
    echo "put 'iflyrd:test1',"$line",'cf:type2','20160518000000'" | hbase shell;  
done  
