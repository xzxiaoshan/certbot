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
    sudo docker exec -i $containerName /bin/bash -c '/opt/shell/renewCmd.sh'
    #3.获取生成的证书的路径
    ca_domain=`sudo docker exec -i $containerName /bin/bash -c 'ls -F /etc/letsencrypt/live/ | grep /$ | head -n1'`
    if [ "$ca_domain"x != ""x ]; then
        ca_domain=${ca_domain%/*}
        docker_ca_dir="/etc/letsencrypt/live/"$ca_domain

        #4.拷贝证书文件到群晖系统临时目录/tmp/
        #4.1先删除
        sudo rm -rf /tmp/cert.pem
        sudo rm -rf /tmp/chain.pem
        sudo rm -rf /tmp/fullchain.pem
        sudo rm -rf /tmp/privkey.pem
        #4.2后拷贝
        sudo docker cp -L $containerName:$docker_ca_dir/cert.pem /tmp/
        sudo docker cp -L $containerName:$docker_ca_dir/chain.pem /tmp/
        sudo docker cp -L $containerName:$docker_ca_dir/fullchain.pem /tmp/
        sudo docker cp -L $containerName:$docker_ca_dir/privkey.pem /tmp/
        
        #5.判断4个文件都拷贝成功
        if [ -f "/tmp/cert.pem" ] && [ -f "/tmp/chain.pem" ] && [ -f "/tmp/fullchain.pem" ] && [ -f "/tmp/privkey.pem" ]; then
            echo "copy docker cert success(To /tmp/)"
            #6.获取群晖所有证书，然后用/tmp/下面的证书进行匹配，将证书subject一致的证书进行全部替换
            #6.1获取要更新的证书的subject
            sourceSubject=`sudo openssl x509 -in /tmp/cert.pem -noout -subject`
            echo "sourceSubject="$sourceSubject
            #6.2获取群和所有证书
            certList=`find /usr/syno/etc/certificate/ /usr/local/etc/certificate/ -name cert.pem`
            for cert in $certList
            do
                subject=`sudo openssl x509 -in $cert -noout -subject`
                echo "targetSubject="$subject
                if [ "$sourceSubject"x = "$subject"x ]; then
                    synoCertDir=${cert%/*}
                    echo "证书匹配,目录=$synoCertDir"
                    #7.将上面存储到/tmp/中的自定义证书文件，覆盖群晖默认证书文件
                    sudo /usr/bin/cp -f /tmp/cert.pem $synoCertDir/cert.pem
                    sudo /usr/bin/cp -f /tmp/chain.pem $synoCertDir/chain.pem
                    sudo /usr/bin/cp -f /tmp/fullchain.pem $synoCertDir/fullchain.pem
                    sudo /usr/bin/cp -f /tmp/privkey.pem $synoCertDir/privkey.pem
                fi
            done
            #8.nginx -s reload 使新证书生效
            sudo nginx -s reload
            
            echo "The End (SUCCESS)"
        fi
    fi
fi

