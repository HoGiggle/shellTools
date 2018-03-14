#!/bin/bash
source ~/.bashrc
WORK_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
crontab -l > $WORK_PATH/crontab 
