#!/bin/bash

# 导入依赖

source ../env/env.sh




## 初始化 ##

# network check
echo "Start testing network connecting..."

for ip  in ${K8S_HOSTS}
do
	ping -c 3 -i 0.2 -W 3 $ip >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
	echo "$IP host is faild" && exit -1
	fi
done