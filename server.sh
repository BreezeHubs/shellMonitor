#!/bin/bash

#周期性调用
timer=30s
while true; do
    data=$(./module/collect.sh) #采集数据

    #存储数据
    time=$(date)
    ./module/store.sh "###########$time###########"
    ./module/store.sh "$data"
    ./module/store.sh "###########$time###########\n"

    #休眠保证周期时间
    sleep $timer
done