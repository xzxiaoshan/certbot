#!/bin/bash
crond start && /opt/shell/letsCert_inside.sh & 
tail -f /dev/null
