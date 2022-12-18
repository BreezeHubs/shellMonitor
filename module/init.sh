#!/bin/bash

function CollectUse() {
    _use_file=$(dirname $0)'/collectFunc/'
    for file in $(ls $_use_file | grep '.sh'); do
        . $_use_file$file #. ./xxx.sh 引入sh文件
    done
}
