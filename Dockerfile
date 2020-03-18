FROM centos:centos8
MAINTAINER xzxiaoshan <365384722@qq.com>

ENV TZ="Asia/Shanghai"
WORKDIR /opt/

VOLUME ["/etc/letsencrypt","/var/log/certbot.log","/var/log/certd.log"]

COPY certbot-au /opt/certbot-au
COPY shell /opt/shell

ENV PDNS=aly
ENV ALY_TOKEN=""
ENV ALY_KEY=""
ENV CERT_PARAMS="--email youremail@qq.com -d yourdomain.com -d *.yourdomain.com"

RUN set -x && \
  && rm -rf /etc/localtime \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && yum install -y wget python36 cronie crontabs \
  && ln -s /usr/bin/python3.6 /usr/bin/python \
  && wget https://dl.eff.org/certbot-auto \
  && mv certbot-auto /usr/local/bin/certbot-auto \
  && chown root /usr/local/bin/certbot-auto \
  && chmod 0755 /usr/local/bin/certbot-auto \
  && mkdir -p /etc/letsencrypt/renewal \
  && sed -i 's/^\(ALY\|TXY\|HWY\|GODADDY\)/#&/' /opt/certbot-au/au.sh \
  && sed -ri 's/.*pam_loginuid.so/#&/' /etc/pam.d/crond \
  && (crontab -l; echo "*/1 * * * * /opt/shell/letsCert_inside.sh" ) | crontab

ENTRYPOINT ["/opt/shell/entrypoint.sh"]
