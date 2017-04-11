#!/bin/bash
# usage :
#for client config,when openvpn in the stage route-up,or route-pre-down,add or delet iptables
#put these line in the client config file
#route-up client.sh
#route-pre-down
#and make sure you have "script-security 2" in the config file
source_ip=`ip route show dev eth0|awk 'NR==2 {print $1}'` #if your local network interface is not eth0,you dead.
if [ "$script_type" = "route-up" ];
then
        ip=$ifconfig_local
        /sbin/iptables -t nat -A POSTROUTING -s $source_ip -o tun0 -j SNAT --to-source $ip
elif [ "$script_type" = "route-pre-down" ];
then
        ip=$ifconfig_local
        /sbin/iptables -t nat -D POSTROUTING -s $source_ip -o tun0 -j SNAT --to-source $ip

fi

exit 0
