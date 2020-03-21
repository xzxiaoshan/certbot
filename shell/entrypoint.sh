#!/bin/bash
mkdir -p /etc/letsencrypt/synology && \cp -p /opt/shell/syncSynologyCert.sh /etc/letsencrypt/synology/
crond start && /opt/shell/letsCert_inside.sh & 
tail -f /dev/null
