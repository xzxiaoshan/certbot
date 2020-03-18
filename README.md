# certbot
certbot 免费泛域名证书的生成，一键生成，自动续期。

### 使用示例
```
docker run -itd --name xzxiaoshan-certbot \
-v /opt/certbot/logs:/var/log/letsencrypt \
-v /opt/certbot/logs/certbot.log:/var/log/certbot.log \
-v /opt/certbot/letsencrypt:/etc/letsencrypt \
-e ALY_TOKEN=XXXXXXXXXX \
-e ALY_KEY=XXXXXXXXX -e PDNS=aly \
-e CERT_PARAMS="--email example@qq.com -d example.com -d *.example.com" \
xzxiaoshan/xzxiaoshan-certbot:latest /bin/bash
```

### 附：群晖证书自动同步脚本
1、脚本下载地址：https://raw.githubusercontent.com/xzxiaoshan/certbot/master/shell/syncSynologyCert.sh
2、脚本使用方法：修改脚本中第一个变量`letsencrypt_path`的路径值（脚本中有说明）
3、使用群晖的定时任务，每天执行一次该脚本即可。

---

（END）
