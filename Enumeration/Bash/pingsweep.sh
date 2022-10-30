#!/bin/bash
IP=$1
for i in {1..254} ;do (ping -c 1 $IP.$i | grep "bytes from" &) ;done
