#!/bin/bash
#CERT_PARAMS="--email 365384722@qq.com -d xxx.com -d *.xxx.com"
echo $CERT_PARAMS
CMD="echo 'Y' | certbot-auto certonly ${CERT_PARAMS} --agree-tos --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory --manual --manual-auth-hook '/opt/certbot-au/au.sh python aly add' --manual-cleanup-hook '/opt/certbot-au/au.sh python aly clean'"
eval $CMD
