#!/bin/bash
for oneDay in $(cat dateList) 
do
   #hadoop fs -mv /user/iflyrd/.Trash/Current/user/iflyrd/kuyin/input/rawlog/$oneDay /user/iflyrd/kuyin/input/rawlog/$oneDay
   hadoop fs -mv /user/iflyrd/.Trash/Current/user/iflyrd/kuyin/inter/hotRank/$oneDay /user/iflyrd/kuyin/inter/hotRank/$oneDay
done
