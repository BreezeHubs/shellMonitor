#!/bin/bash

#监控内存及交换分区的使用情况
__memCommand='free -m' #物理内存描述信息，#以M为单位

#总的可用物理内存
function GetMemTotal() {
    echo $($__memCommand | grep Mem | awk '{print $2}')
}

#已使用的物理内存
function GetMemUsed() {
    echo $($__memCommand | grep Mem | awk '{print $3}') 
}

#剩余可用的物理内存
function GetMemFree() {
    echo $($__memCommand | grep Mem | awk '{print $4}') 
}

#多个进程共享的内存总额
function GetMemShare() {
    echo $($__memCommand | grep Mem | awk '{print $5}') 
}

#buff表示I/O缓存、cache表示高速缓存
function GetMemBuffCache() {
    echo $($__memCommand | grep Mem | awk '{print $6}') 
}

#还可以被应用程序使用的物理内存
function GetMemAvailable() {
    echo $($__memCommand | grep Mem | awk '{print $7}') 
}