#!/bin/bash

# 导入依赖

source ./env/env.sh


# 打印信息
echo "你正在进行k8s集群操作，集群个节点信息如下:"
echo "${K8S_MASTER01}:${K8S_MASTER01_IP}"
echo "${K8S_MASTER02}:${K8S_MASTER02_IP}"
echo "${K8S_MASTER03}:${K8S_MASTER03_IP}"
echo "${K8S_NODE01}:${K8S_NODE01_IP}"
echo "${K8S_NODE01}:${K8S_NODE02_IP}"

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
