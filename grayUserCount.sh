#!/bin/bash
for oneDay in $(cat dateList) 
do
    num=$(hadoop fs -cat /user/iflyrd/kuyin/inter/mvDayGrayUser/$oneDay/* | wc -l)
    echo "Day gray $oneDay: $num" 
    
    new=$(hadoop fs -cat /user/iflyrd/kuyin/inter/mvNewGrayUser/$oneDay/* | wc -l)
    echo "New gray $oneDay: $new" 
done
