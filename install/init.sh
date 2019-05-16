#!/bin/bash

# install ansible
INSTALL_ANSIBLE(){
yum install -y epel-release && yum install ansible -y
## 定义主机组
if [ -f "/etc/ansible/hosts" ]
then
cat >> /etc/ansible/hosts << EOF
[k8s-master]
${K8S_MASTER01_IP}
${K8S_MASTER02_IP}
${K8S_MASTER03_IP}
[k8s-node]
${K8S_NODE01_IP}
${K8S_NODE02_IP}
[k8s-all]
${K8S_MASTER01_IP}
${K8S_MASTER02_IP}
${K8S_MASTER03_IP}
${K8S_NODE01_IP}
${K8S_NODE02_IP}
EOF
else
	echo "ansible install falied."
	exit 1
fi
}