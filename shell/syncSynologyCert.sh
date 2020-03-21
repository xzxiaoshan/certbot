#!/bin/bash
###############################################################################################################
# @脚本说明  更新群晖的同域名证书
# @前提条件  该脚本配套DockerHub中的xzxiaoshan/certbot
# @author    SHANHY
# @email     365384722@qq.com
# @date      2002-03-18
###############################################################################################################

#你挂载到docker的目录路径，这个注意不要修改错了（在群晖中右键文件夹》查看属性》所在位置》复制），最后没有“/”
#letsencrypt_path=/volume1/docker/certbot/letsencrypt
current_path=$(cd "$(dirname $0)";pwd -P)
cd $current_path

#获取生成的证书的路径
#ca_domain=`ls -F ${letsencrypt_path}/live/ | grep /$ | head -n1`
ca_domain=`ls -F ../live/ | grep /$ | head -n1`
echo $ca_domain
if [ "$ca_domain"x != ""x ]; then
	ca_domain=${ca_domain%/*}
	#ca_dir=$letsencrypt_path"/live/"$ca_domain
	ca_dir="../live/"$ca_domain

	if [ -f "${ca_dir}/cert.pem" ] && [ -f "${ca_dir}/chain.pem" ] && [ -f "${ca_dir}/fullchain.pem" ] && [ -f "${ca_dir}/privkey.pem" ]; then
		echo "copy docker cert success(To /tmp/)"
		#获取群晖所有证书，然后用/tmp/下面的证书进行匹配，将证书subject一致的证书进行全部替换
		#获取要更新的证书的subject
		sourceSubject=`sudo openssl x509 -in ${ca_dir}/cert.pem -noout -subject`
		echo "sourceSubject="$sourceSubject
		#获取群晖所有证书
		certList=`find /usr/syno/etc/certificate/ /usr/local/etc/certificate/ -name cert.pem`
		for cert in $certList
		do
			subject=`sudo openssl x509 -in $cert -noout -subject`
			echo "targetSubject="$subject
			if [ "$sourceSubject"x = "$subject"x ]; then
				synoCertDir=${cert%/*}
				echo "证书匹配,目录=$synoCertDir"
				#将上面存储到/tmp/中的自定义证书文件，覆盖群晖默认证书文件
				sudo /usr/bin/cp -f ${ca_dir}/cert.pem $synoCertDir/cert.pem
				sudo /usr/bin/cp -f ${ca_dir}/chain.pem $synoCertDir/chain.pem
				sudo /usr/bin/cp -f ${ca_dir}/fullchain.pem $synoCertDir/fullchain.pem
				sudo /usr/bin/cp -f ${ca_dir}/privkey.pem $synoCertDir/privkey.pem
			fi
		done
		#nginx -s reload 使新证书生效
		sudo nginx -s reload
		
		echo "The End (SUCCESS)"
	fi
fi

