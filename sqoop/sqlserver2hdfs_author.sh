#!/bin/bash

#running setting
#outputPath=/user/iflyrd/kuyin/ringinfo/UserRingInfo
outputPath=/user/iflyrd/work/jjhu/kuyin/Author
mysqlUrl='jdbc:sqlserver://1.1.1.1:1433;instance=SQLEXPRESS;username=123;password=123;database=123'
partitionKey=userid
partition=64
table=authorUser

hadoop fs -rm -r $outputPath
#sqoop import --connect "$mysqlUrl" --table "$table" --split-by "$partitionKey" --fields-terminated-by "~" --target-dir "$outputPath" -m "$partition" --null-string '' --null-non-string ''
sqoop import --connect "$mysqlUrl" --table "$table" --split-by "$partitionKey" --fields-terminated-by "" --target-dir "$outputPath" -m "$partition" --null-string '' --null-non-string ''
