#!/bin/bash
#CERT_PARAMS="--email 365384722@qq.com -d xxx.com -d *.xxx.com"
echo $CERT_PARAMS
CMD="echo 'Y' | /usr/local/bin/certbot certonly ${CERT_PARAMS} --agree-tos --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory --manual --manual-public-ip-logging-ok --manual-auth-hook '/opt/certbot-au/au.sh python ${PDNS} add' --manual-cleanup-hook '/opt/certbot-au/au.sh python ${PDNS} clean'"
eval $CMD
