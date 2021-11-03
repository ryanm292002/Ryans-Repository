$

egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/access.log | sort -u | tee badIPs.txt


for eachIP in $(cat badIPs.txt)
do

        echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
done
~
~

