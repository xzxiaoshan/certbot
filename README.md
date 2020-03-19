# certbot  
certbot 免费泛域名证书的生成，容器启动自动生成，容器自动证书自动续期（按官方证书即将到期的30天）。   
目前支持阿里云 DNS、腾讯云 DNS、华为云 NDS、GoDaddy。  

### 使用方法 
**命令代码**  
```
docker run -itd --name xzxiaoshan-certbot \
-v /opt/certbot/logs:/var/log/letsencrypt \
-v /opt/certbot/letsencrypt:/etc/letsencrypt \
-e ALY_TOKEN=XXXXXXXXXX \
-e ALY_KEY=XXXXXXXXX -e PDNS=aly \
-e CERT_PARAMS="--email example@qq.com -d example.com -d *.example.com" \
xzxiaoshan/xzxiaoshan-certbot:latest /bin/bash
```
**参数说明**  
* PDNS参数：阿里云`aly`、腾讯云`txy`、华为云`hwy`、GoDaddy `godaddy` 
* ALY_KEY 和 ALY_TOKEN：阿里云 [API key 和 Secrec 官方申请文档](https://help.aliyun.com/knowledge_detail/38738.html)。
* TXY_KEY 和 TXY_TOKEN：腾讯云 [API 密钥官方申请文档](https://console.cloud.tencent.com/cam/capi)。
* HWY_KEY 和 HWY_TOKEN: 华为云 [API 密钥官方申请文档](https://support.huaweicloud.com/devg-apisign/api-sign-provide.html)。
* GODADDY_KEY 和 GODADDY_TOKEN：GoDaddy [API 密钥官方申请文档](https://developer.godaddy.com/getstarted)。
* 支持的域名后缀详见文件[domain.ini](https://raw.githubusercontent.com/xzxiaoshan/certbot/master/certbot-au/domain.ini)。如果没有你的后缀，请邮件联系`365384722@qq.com`添加。
上面命令通用于Linux，如果你是群晖直接通过群晖界面配置环境变量和卷挂载即可，其他设备同理。  

**注意事项**  
* 容器除此创建运行时，certbot会构建运行环境，这个需估计需要几分钟时间，需要等待一下。  
* 配置运行环境的过程中，如果你没有科学上网，那么可能会因为网络不好而出现错误（只要你再日志中搜索存在`timeout`就可以确定），然后你只需要重启容器即可，直到没有类似的网络问题错误。  
* 日志在`certbot.log`文件中可能看到。  

### 附：群晖证书自动同步脚本  
1、脚本下载地址：https://raw.githubusercontent.com/xzxiaoshan/certbot/master/shell/syncSynologyCert.sh  
2、脚本使用方法：修改脚本中第一个变量`letsencrypt_path`的路径值（脚本中有说明）  
3、使用群晖的定时任务，每天执行一次该脚本即可。  

---

感谢[certbot-au](https://github.com/ywdblog/certbot-letencrypt-wildcardcertificates-alydns-au)代码的作者。  

---

（END）
