#!/bin/bash
# Portscan script that grabs quickly grabs open ports, then scans each open port in detail automatically.
findports=$(nmap -p- --host-timeout 201 --max-retries 0 --min-rate=1000 -T4 $1 | grep '^[0-9]*/tcp' | cut -d "/" -f1 | tr "\n" "," | sed s/.$//)
nmap -T4 -A -p $findports $1 -oN open-ports
