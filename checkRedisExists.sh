for line in $(cat myTmp)
do
    result=$(echo "exists uc_$line" | redis-cli -n 5)
    if [ "$result" = "1" ];then
        echo $line >> redisCheckRes
    fi
done
