#!/bin/bash

source ~/.bashrc

WORKPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );
MAIL_LIST="jjhu2@iflytek.com";
# a=$(date +"%s")
# b=$(date  +"%s" -d  "-10minute")  获取系统10分钟之前的时间戳
# c=$(date -d @$b  "+%Y-%m-%d %H:%M:%S")  将时间戳转换为指定格式的时间字符串
# d=$(date -d "$c" +%s) 将时间字符串转换成时间戳
# e=$(date -d "$c 10 min ago" +"%Y-%m-%d %H:%M:%S") 获取当前时间10分钟时间
# e=$(date -d "-10 minute $c" +"%Y-%m-%d %H:%M:%S")
# f=`expr $a - 600` 获取当前时间戳600秒前的时间戳
function get_10ago_timestamp() {
	ago_10=$(date  +"%s" -d  "-10minute")
	# Hbase shell 中的timestamp 必须是13位，因此后面再加000
	echo ${ago_10}"000"
}

function check_hbase_data() {
	local RDATE="$1";
	local TABLE="$2";

	timestamp=$(date +"%s") #当前时间戳
	timestamp_10_ago=`expr $timestamp - 1800` #30分钟之前时间戳

	CDATE=$(date +"%Y-%m-%d %H:%M:%S")
	# bash -x $WORKPATH/put_hbase.sh $RDATE "Test" "1";
	echo "scan '$TABLE',{TIMERANGE=>[${timestamp_10_ago}"000",${timestamp}"000"],LIMIT=>1}"|\
		hbase shell > $WORKPATH/$RDATE.log;
	#验证指定时间戳范围内是否有数据写入
	cat $WORKPATH/$RDATE.log|grep '1 row(s)';

	if [[ $? -ne 0 ]]; then
		echo "$TABLE 在当前[$CDATE] 10分钟之内无数据写入" >> $WORKPATH/'error_'$RDATE.log;
		# exit 1;
	fi
}

function sendmail() {
        cd $WORKPATH;
        echo "MAIL_LIST=$MAIL_LIST
MAIL_USER=
MAIL_PASS=
SUBJECT=$2
CONTENT=$1
ATTACHMENT=$3">mail.conf
        python $WORKPATH/utils/SendmailUtil.py mail.conf;
}


function main() {
        while(true)
        do
            local RDATE=$(date +%Y%m%d);

            rm -rf $WORKPATH/*.log || true;
            # 新闻实时点击率榜单
            check_hbase_data "$RDATE" "iflyrd:FalcoDocCliRateRank"
            # 新闻实时点击率有效阅读榜单
            check_hbase_data "$RDATE" "iflyrd:FalcoDocCliRateRank_ValidRead"

            # 判断错误文件是否存在且非空
            if [ -s $WORKPATH/'error_'$RDATE.log ]; then
                # 发送告警邮件
                sendmail "相关Hbase表当前10分钟之内无数据生成" "近10分钟监测结果" "$WORKPATH/error_$RDATE.log";
                hour=`date +%H`
                if [ $hour -ge 07 ] && [ $hour -le 22 ];then
                        python $WORKPATH/SendSms.py $WORKPATH/error_$RDATE.log;
                        # sendmail "相关Hbase表当前4分钟之内无数据生成" "近4分钟监测结果" "$WORKPATH/error_$RDATE.log";

                fi
            fi          

            rm -rf $WORKPATH/*.log
            sleep 30m #30分钟check一次
        done 
}

# 程序执行时间入口
main
