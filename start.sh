#!/bin/bash
#Running spark application with spark-submit, common template. 

#***********************************************************************************************
#Variable setting.                                                                                
#***********************************************************************************************
#Environment set.
SPARK_HOME="$SPARK_HOME"
HADOOP_HOME="$HADOOP_HOME"
WORK_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER="iflyrd"
APP_NAME="kuyin"

#Spark parameter set.
DRIVER_MEMORY=512m
EXECUTOR_MEMORY=2g
NUM_EXECUTORS=4
EXECUTOR_CORES=4
MASTER_MODE=yarn-cluster
QUEUE=spark
CLASS_PATH="com.iflytek.strategy.ProfileRecBatch"
ONLINE_JAR_PATH="/home/$USER/uba/$PRODUCT/online"
JAR_VERSION="lydia-0.1.0.jar"
#***********************************************************************************************
#Function area.                                                                                
#***********************************************************************************************
function main(){
    $SPARK_HOME/bin/spark-submit \
    --driver-memory ${DRIVER_MEMORY} \
    --executor-memory ${EXECUTOR_MEMORY} \
    --num-executors ${NUM_EXECUTORS} \
    --executor-cores ${EXECUTOR_CORES} \
    --master ${MASTER_MODE} \
    --queue ${QUEUE} \
    --files $WORK_PATH/$CLASS_PATH$.conf \
    --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=log4j.properties" \
    --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=log4j.properties" \
    --conf "spark.shuffle.memoryFraction=0.6" \
    --conf "spark.storage.memoryFraction=0.2" \
    --class ${CLASS_PATH} \
    $ONLINE_JAR_PATH/$JAR_VERSION \
    "$1" \
    "$2"
}

:<<!
  The func returns a HDFS format date range, by one date and length.  
  e.g. =>
  in:  $1=20171026,$2=3
  out: {20171026,20171025,20171024}
!
function getDateRange_V1(){
    local CDATE=$(date +%Y%m%d --date="$1")
    local startRow=$CDATE
    local hdfsEndDate=$(date +%Y%m%d --date="$CDATE")
    local hdfsRange="{"$hdfsEndDate;
    for ((i=1; i<$2; i++))
    do
        hdfsday=`date +%Y%m%d --date="$hdfsEndDate-$i day"`;
        hdfsRange=$hdfsRange","$hdfsday;
    done
    hdfsRange=$hdfsRange"}"
    echo $hdfsRange
}

:<<!
  The func return a HDFS format date range, by two dates. 
  e.g. =>
  in:  $1=20160505, $2=20160508
  out: {20160505,20160506,20160507,20160508}
!
function getDateRange_V2(){
    result="{"
    startDay=$1
    i=1
    while [ "$startDay" \< "$2" ] #-o "$startDay" = "$2" ]
    do
        result=""$result""$startDay","
        seconds=$(date -d "$startDay" +%s)
        seconds=$(($seconds+86400))
        startDay=$(date -d @$seconds "+%Y%m%d")
        i=$(($i+1))
    done

    result=""$result""$startDay"}"
    echo $result
}
#************************************************************************************************************
#Run main function, to commit spark job.
#************************************************************************************************************
:<<!
if [ -z "$1" ];then
   echo "同学, 输入正确日期啊!"
   exit 0
fi
echo "不要怂, 这次有参数!"
!

cd $WORK_PATH
cDate=$(date +%Y%m%d --date="$1")
$HADOOP_HOME/bin/hadoop fs -rm -r /user/$USER/$APP_NAME/strategy/recommendResult/$cDate/profileR
main "$1" "$cDate"
