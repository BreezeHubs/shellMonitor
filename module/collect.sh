#!/bin/bash

. $(dirname $0)/init.sh

CollectUse #加载collect的函数

diskKey=$(GetAllDiskMounted) #获取所有挂载点
diskDataJson='' #disk数据json
for key in ${diskKey}; do
    data=$(GetAllDisk "$key") #获取挂载点的数据
    diskDataJson=$diskDataJson"    -
        file_system: $(echo $data | awk '{print $1}')
        blocks: $(echo $data | awk '{print $2}')M
        used: $(echo $data | awk '{print $3}')M
        available: $(echo $data | awk '{print $4}')M
        used_rate: $(echo $data | awk '{print $5}')
        mounted: $(echo $data | awk '{print $6}')
"
done

memTotal=$(GetMemTotal)
memUsed=$(GetMemUsed)
cpuFreeRate=$(GetCPUFree)
#拼接数据
str="cpu[
    used_rate: $(awk 'BEGIN{printf "%.2f%\n",(100-'$cpuFreeRate')}')
]cpu
memory[
    total: "$memTotal"M
    used: "$memUsed"M
    free: $(GetMemFree)M
    share: $(GetMemShare)M
    buffcache: $(GetMemBuffCache)M
    available: $(GetMemAvailable)M
    used_rate: $(awk 'BEGIN{printf "%.2f%\n",('$memUsed'/'$memTotal')*100}')
]memory
disk[
${diskDataJson}
]disk"
echo -e "$str"