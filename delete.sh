#!/bin/bash
for line in $(cat uid.txt)  
do  
    echo "deleteall 'iflyrd:FalcoGrayUid',"$line"" | hbase shell;  
done  
