#!/bin/bash



# network check
CHECK_NETWORK(){
echo "Start testing network connecting..."

for ip  in ${K8S_HOSTS}
do
	ping -c 3 -i 0.2 -W 3 $ip >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
	echo "$ip host is faild" && exit -1
	fi
done
}

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

# firewalld selinux
FIREWALLD_INIT(){
ansible k8s-all -m shell -a 'systemctl stop firewalld'
ansible k8s-all -m shell -a 'systemctl disable firewalld'
ansible k8s-all -m shell -a 'setenforce  0'
ansible k8s-all -m replace -a 'path=/etc/sysconfig/selinux regexp="SELINUX=enforcing" replace=SELINUX=disabled'
ansible k8s-all -m replace -a 'path=/etc/selinux/config regexp="SELINUX=enforcing" replace=SELINUX=disabled'
}

# kernel
SET_K8S_KERNEL(){
cat >> /etc/sysctl.d/k8s.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
ansible k8s-all -m copy -a "src=/etc/sysctl.d/k8s.conf dest=/etc/sysctl.d/k8s.conf"
ansible k8s-all -m shell -a 'modprobe br_netfilter'
ansible k8s-all -m shell -a 'sysctl -p /etc/sysctl.d/k8s.conf'
}

# set hostname

HOSTNAME_SET(){
cat >> /etc/hosts << EOF
K8S_MASTER01_IP 10.10.0.18
K8S_MASTER02_IP 10.10.0.19
K8S_MASTER03_IP 10.10.0.20
K8S_NODE01_IP 10.10.0.21
K8S_NODE02_IP 10.10.0.22
EOF
ansible k8s-all -m copy -a "src=/etc/hosts dest=/etc/hosts"
ansible $K8S_MASTER01_IP -m shell -a "hostnamectl set-hostname K8S_MASTER01"
ansible $K8S_MASTER02_IP -m shell -a "hostnamectl set-hostname K8S_MASTER02"
ansible $K8S_MASTER03_IP -m shell -a "hostnamectl set-hostname K8S_MASTER03"
ansible $K8S_NODE01_IP -m shell -a "hostnamectl set-hostname K8S_NODE01"
ansible $K8S_NODE02_IP -m shell -a "hostnamectl set-hostname K8S_NODE02"
}
# sync time
TIME_CRON_INIT(){
ansible k8s-all -m yum -a "name=ntpdate state=latest"
ansible k8s-all -m cron -a "name='k8s cluster crontab' minute=*/30 hour=* day=* month=* weekday=* job='ntpdate time7.aliyun.com >/dev/null 2>&1'"
ansible k8s-all -m shell -a "systemctl restart crond"
ansible k8s-all -m shell -a "ntpdate time7.aliyun.com"
}

# create dir 
CREATE_DIR(){
ansible k8s-all -m file -a 'path=/etc/kubernetes/ssl state=directory'
ansible k8s-all -m file -a 'path=/etc/kubernetes/config state=directory'
mkdir /opt/k8s/{certs,cfg,unit} -p
}