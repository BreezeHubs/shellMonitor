#!/bin/bash

#获取最新数据
function __getLastData() {
    local dataFile=$(dirname $0)'/../data/.data'

    #cat显示行数，找到同小时内的时间行数据，过滤空行，获取最后两条（为时间内的开始和结束行），取开始行，取第一列（行数）
    local line=$(cat -n $dataFile | grep "###########$(date +'%a %b %d %H')" | tr -s '\n' | tail -2 | head -1 | awk '{print $1}')
    if [[ $line -eq 0 ]]; then
        echo '数据查找失败'
        exit
    fi

    local data=$(tail -n +$line $dataFile) #从开始行读取
    # echo -e "$data"

    #去掉时间行的数据
    local dataString=$(echo -e "$data" | grep -v '###########')
    echo -e "$dataString"
}

#匹配字符之间的内容
#dataString参数要加双引号
function __getBetweenString() {
    dataString=$1
    key=$2

    #去掉右边分界符：]+$key
    local dataStrCutRight=$(echo -e "${dataString%]$key*}")
    # echo -e "$dataStrCutRight"

    #去掉左边分界符：$key+[]
    local dataStrCutLeft=$(echo -e "${dataStrCutRight#*$key[}")
    # echo -e "$dataStrCutLeft"

    #去掉空白行
    local dataString=$(echo "$dataStrCutLeft" | sed -e '/^$/d')
    echo -e "$dataString"
}

#获取数据
function Get() {
    #up_since、memory、disk、cpu
    local key=$1 #获取数据项传参

    #获取最新数据
    local dataString=$(__getLastData)

    #判断是否存在要找的数据项
    if [[ $(echo $dataString | grep $key | wc -l) -eq 0 ]]; then
        echo '查找的数据不存在'
        exit
    fi

    #去掉分界符
    local dataString=$(__getBetweenString "$dataString" $key)
    
    echo -e "$key 最新数据为：\n"
    echo -e "$dataString"
}

#获取指标
function Target() {
    #获取最新数据
    local dataString=$(__getLastData)
    # echo -e "$dataString"

    #指标线
    limit=85

    echo '使用率统计: '
    #查cpu数据
    local cpuDataString=$(__getBetweenString "$dataString" "cpu")
    echo -e 'cpu: '$(echo -e "$cpuDataString" | grep 'used_rate' | awk '{if(int($2)>'$limit'){printf $2" [异常]"} else{print $2" [正常]"}}')
    echo '------------------------------'

    #查memory数据
    local memDataString=$(__getBetweenString "$dataString" "memory")
    echo -e '内存: '$(echo -e "$memDataString" | grep 'used_rate' | awk '{if(int($2)>'$limit'){print $2" [异常]"} else{print $2" [正常]"}}')
    echo '------------------------------'

    #查disk数据
    local diskDataString=$(__getBetweenString "$dataString" "disk")
    echo '磁盘: '
    echo -e "$(echo -e "$diskDataString" | 
        grep 'file_system\|mounted\|used_rate' | 
        awk '{if(NR%3==0){print} else{printf "%s ",$0}}' | 
        awk '{if(int($4)>'$limit'){print $2,$6,$4,"[异常]"} else{print $2,$6,$4,"[正常]"}}' |
        awk '{printf "   %-30s: %-3s %s\n", $1" ("$2")",$3,$4}'
        )"
}

if [[ $1 == 'get' ]];then
   Get $2
elif [[ $1 == 'target' ]];then
   Target
fi