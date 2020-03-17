#!/bin/bash
CMD="certbot-auto renew --manual --manual-public-ip-logging-ok --preferred-challenges dns --manual-auth-hook '/opt/certbot-au/au.sh python aly add' --manual-cleanup-hook '/opt/certbot-au/au.sh python aly clean'"
eval $CMD
