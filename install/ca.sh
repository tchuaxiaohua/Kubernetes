#!/bin/bash



mkdir /root/k8s/cfssl
cd /root/k8s/cfssl
for CFFSSL in $TOOLS_GRUOP
do
wget https://pkg.cfssl.org/R1.2/$CFFSSL --no-check-certificate
if [ -f "$CFFSSL" ]
then
	chmod +x  $CFFSSL
	CFFSSL_NAME=$CFFSSL
	file_name=${CFFSSL_NAME%_*}
	cp $CFFSSL /usr/local/bin/$file_name
else
	exit 0 && echo "cfssl tools download faild."
fi
done
