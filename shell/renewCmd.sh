#!/bin/bash
CMD="/usr/local/bin/certbot-auto renew --manual --manual-public-ip-logging-ok --preferred-challenges dns --manual-auth-hook '/opt/certbot-au/au.sh python ${PDNS} add' --manual-cleanup-hook '/opt/certbot-au/au.sh python ${PDNS} clean'"
eval $CMD
