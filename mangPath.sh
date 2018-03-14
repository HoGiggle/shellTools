#!/bin/bash
#Used to get spark complex input path.
# in:20160505 20160508  out:{20160505,20160506,20160507,20160508}
function link(){
    #date +%Y%m%d -s $1
    #startDay=$(date +%Y%m%d)

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


today=$(date +%Y%m%d)
inpath=$(link $1 $2)
echo $inpath

