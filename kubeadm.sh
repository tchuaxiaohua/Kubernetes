#!/bin/bash

# 导入依赖

source ./env/env.sh
source ./install/init.sh
source ./install/ca.sh


# 打印节点信息
echo "你正在进行k8s集群部署操作，集群各个节点信息如下:"
echo "${K8S_MASTER01}:${K8S_MASTER01_IP}"
echo "${K8S_MASTER02}:${K8S_MASTER02_IP}"
echo "${K8S_MASTER03}:${K8S_MASTER03_IP}"
echo "${K8S_NODE01}:${K8S_NODE01_IP}"
echo "${K8S_NODE02}:${K8S_NODE02_IP}"

## 系统初始化开始 ##

CHECK_NETWORK
INSTALL_ANSIBLE
FIREWALLD_INIT
SET_K8S_KERNEL
TIME_CRON_INIT
CREATE_DIR

## 系统初始化结束 ##

## 集群根证书
CA_CREATE
