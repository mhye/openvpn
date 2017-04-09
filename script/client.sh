#!/bin/bash
# usage :
#for client config,when openvpn in the stage route-up,or route-pre-down,add or delet iptables
#put these line in the client config file
#route-up client.sh
#route-pre-down
#and make sure you have "script-security 2" in the config file
source="0.0.0.0/0" #locat network area,such as ：192.168.1.0/24
if [ "$script_type" = "route-up" ];
then
        ip=$ifconfig_local
        /sbin/iptables -t nat -A POSTROUTING -s $source -o tun0 -j SNAT --to-source $ip
elif [ "$script_type" = "route-pre-down" ];
then
        ip=$ifconfig_local
        /sbin/iptables -t nat -D POSTROUTING -s $source -o tun0 -j SNAT --to-source $ip

fi

exit 0
