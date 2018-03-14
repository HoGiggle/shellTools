#!/bin/bash
source ~/.bashrc
WORK_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
redis-cli –h 1.1.1.1 –p 6379 –n 0 keys "res:recom:fancy:*" > tmp
cat tmp | xargs redis-cli –h 1.1.1.1 –p 6379 –n 0 del
rm tmp

