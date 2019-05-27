#!/bin/bash

source ./env/env.sh

CA_CREATE(){
mkdir -p /root/k8s/cfssl
cd /root/k8s/cfssl
for CFFSSL in $TOOLS_GRUOP
do
wget https://pkg.cfssl.org/R1.2/$CFFSSL --no-check-certificate
if [ -f "$CFFSSL" ]
then
	chmod +x  $CFFSSL
	CFFSSL_NAME=$CFFSSL
	file_name=${CFFSSL_NAME%_*}
	cp $CFFSSL $SCRIBE_PATH/$file_name
else
	exit 0 && echo "cfssl tools download faild."
fi
done

cp -r ./config/{ca-config.json,ca-csr.json} /opt/k8s/certs/
cd /opt/k8s/certs/
cfssl gencert -initca /opt/k8s/certs/ca-csr.json | cfssljson -bare ca
ansible k8s-all -m copy -a 'src=/opt/k8s/certs/ca.csr dest=/etc/kubernetes/ssl/'
ansible k8s-all -m copy -a 'src=/opt/k8s/certs/ca-key.pem dest=/etc/kubernetes/ssl/'
ansible k8s-all -m copy -a 'src=/opt/k8s/certs/ca.pem dest=/etc/kubernetes/ssl/'
}
