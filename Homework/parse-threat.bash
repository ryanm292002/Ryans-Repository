#!/bin/bash
#Storyline : Extract IPs from https://nowire.champlain.edu/sys320-file/access.log and create a fiewall ruleset

#216.93.144.47 - - [23/Oct/2021:01:19:44 -0400] "POST /CFIDE/adminapi/administrator.cfc? HTTP/1.1" 404 4999 "-" "-"

#wget  https://nowire.champlain.edu/sys320-file/access.log -O /tmp/access.log

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/access.log | sort -u | tee badIPs.txt |\


for eachIP in $(cat badIPs.txt)
do
	#echo "block in from ${eachIP} to any" | tee -a pf.conf

        echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
done



