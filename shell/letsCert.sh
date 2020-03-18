#!/bin/bash
#这个等于号后面是配置你容器的名字
export containerName=xzxiaoshan-certbot

dirpath=/tmp/$RANDOM
echo $dirpath
mkdir $dirpath
sudo docker cp $containerName:/etc/letsencrypt/renewal $dirpath
count=`ls $dirpath/renewal|grep **.conf|wc -w`
rm -rf $dirpath
if [ "$count" -gt "0" ];
then
 sudo rm -rf /tmp/renewCert.sh
 sudo docker cp $containerName:/opt/shell/renewCert.sh /tmp/renewCert.sh
 sudo chmod +x /tmp/renewCert.sh
 sh /tmp/renewCert.sh
else
 sudo rm -rf /tmp/createCert.sh
 sudo docker cp $containerName:/opt/shell/createCert.sh /tmp/createCert.sh
 sudo chmod +x /tmp/createCert.sh
 sh /tmp/createCert.sh
 #下面两行脚本是从容器中取出证书的，如果你需要你可以去掉“井号”
 sudo docker exec -i $containerName /bin/bash -c 'cd /etc/letsencrypt && rm -rf live.zip && zip -r live.zip live/'
 sudo docker cp $containerName:/etc/letsencrypt/live.zip /opt/certbot/live.zip
fi
