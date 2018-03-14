#!/bin/bash
#load mysql data to hdfs

#running setting
outputPath=/user/iflyrd/kuyin/ringinfo/RingShowExRanking
mysqlUrl=jdbc:mysql://1.1.1.1:3306/dataBase
username=123
password=123
#query='select * from table where $CONDITIONS'
query='select RankingID,RingShowID,RingShowType,RingNo,RingName,CreatedTime,UpdatedTime from RingShowExRanking where $CONDITIONS'
partitionKey=id
partition=1

hadoop fs -rm -r $outputPath
sqoop import --connect "$mysqlUrl" --username "$username" --password "$password" --query "$query" --split-by "$partitionKey" --target-dir "$outputPath" --fields-terminated-by "" -m "$partition" --null-string '' --null-non-string ''
