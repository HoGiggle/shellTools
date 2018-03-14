cd /home/iflyrd/uba/develop/jjhu 
echo " scan 'iflyrd:FalcoGrayUid',{COLUMN => 'cf:type', TIMERANGE=>[1463500800000,1463587200000]}" | hbase shell | grep ".*value=2" | cut -c 1-19 > uid.txt

