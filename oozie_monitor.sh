#!/bin/bash

source ~/.bashrc

WORKPATH=$(cd "$(dirname "$0")/"; pwd);

oozieUrl=$1
coordinatorName=$2
workflowName=$3
monitorActionName="Oozie_Monitor"
fileName=$4
toMails=""
ccMails=""
hdfsPath=
date=$5

hadoop fs -rm ${hdfsPath}/*

java -jar $WORKPATH/get_oozie_data.jar ${oozieUrl} ${coordinatorName} ${workflowName} ${monitorActionName} ${fileName} ${toMails} ${ccMails} ${date}

hadoop fs -put $4 $hdfsPath
