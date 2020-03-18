#!/bin/bash
count=`ls /etc/letsencrypt/renewal|grep **.conf|wc -w`
if [ "$count" -gt "0" ];
then
  echo "[`date +%Y-%m-%dT%H:%M:%S`] Exec renewCmd" >> /var/log/certbot.log
  sh /opt/shell/renewCmd.sh >> /var/log/certbot.log 2>&1
else
  echo "[`date +%Y-%m-%dT%H:%M:%S`] Exec createCmd" >> /var/log/certbot.log
  sh /opt/shell/createCmd.sh >> /var/log/certbot.log 2>&1
fi
