#!/bin/bash

__dfCommand='df -hm' #以M为单位

#获取所有挂载点数组，提供遍历对应数据
function GetAllDiskMounted() {
    local all=$($__dfCommand | awk 'NR>1{print $6}')
    OIFS="$IFS";IFS=",";arr=($all);IFS="$OLD_IFS"
    echo $all
}

#获取挂载点的数据，需传入挂载点mounted参数，如：GetAllDisk "/"
function GetAllDisk() {
    echo $($__dfCommand | grep -e $1$)
    # OIFS="$IFS";IFS=" ";arr=($data);IFS="$OLD_IFS"

    # dataArray=(
    #     $(echo $data | awk '{print $1}')
    #     $(echo $data | awk '{print $2}')
    #     $(echo $data | awk '{print $3}')
    #     $(echo $data | awk '{print $4}')
    #     $(echo $data | awk '{print $5}')
    #     $(echo $data | awk '{print $6}')
    # )
    # echo ${dataArray[*]}
}

