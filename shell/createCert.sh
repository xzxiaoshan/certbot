#!/bin/bash
###############################################################################################################
# @脚本说明  自动续期Let's Encrypt签发的90天免费证书，并自动更新群晖NAS的默认证书(证书未到期不会强制更新证书)
# @前提条件  1.已经手工在docker中签发证书 
#            2.并且已经将签发的证书添加配置到群晖NAS中并设置为默认证书 
#            3.该脚本配套DockerHub中的xzxiaoshan/certbot
# @author    SHANHY
# @email     365384722@qq.com
# @date      2019-03-19
###############################################################################################################

#1.获取container name
if [ "$containerName"x = x ]
then
containerName=`sudo docker ps --format "{{.ID}} {{.Image}} {{.Names}}" |grep xzxiaoshan/certbot |head -n 1 |awk '{print $3}'`
fi
if [ "$containerName"x != ""x ]; then
    #2.执行命令续期证书
    sudo docker exec -i $containerName /bin/bash -c '/opt/shell/createCmd.sh'
    echo "The End (SUCCESS)"
fi

