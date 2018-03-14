#!/bin/bash
#hbase快速count大表, $1为完整表名
hbase org.apache.hadoop.hbase.mapreduce.RowCounter "$1"
