#!/bin/bash

## 主机组

K8S_MASTERS="10.10.0.14 10.10.0.15 10.10.0.16"
K8S_HOSTS="10.10.0.14 10.10.0.15 10.10.0.16 10.10.0.17 10.10.0.23"
K8S_NODES="10.10.0.17 10.10.0.23"

# IP
K8S_MASTER01_IP=10.10.0.14
K8S_MASTER02_IP=10.10.0.15
K8S_MASTER03_IP=10.10.0.16
K8S_NODE01_IP=10.10.0.17
K8S_NODE02_IP=10.10.0.23
## 主机名
K8S_MASTER01=k8s-master01
K8S_MASTER02=k8s-master02
K8S_MASTER03=k8s-master03
K8S_NODE01=k8s-node01
K8S_NODE02=k8s-node02

## 集群各组件工具脚本存放路径
SCRIBE_PATH=/usr/local/bin
## PKI 工具集 cfssl 变量组
TOOLS_GRUOP="cfssl_linux-amd64 cfssljson_linux-amd64 cfssl-certinfo_linux-amd64"