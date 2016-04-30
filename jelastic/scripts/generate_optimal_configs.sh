#!/bin/bash

SED=$(which sed);

[ -z "$XMS" ] && { XMS=32; }
memory_total=`free -m | grep Mem | awk '{print $2}'`;
[ -z "$XMX" ] && { let XMX=memory_total-35; }

host_short=$(hostname -s)

sed -i "/$host_short/d" /etc/hosts;
echo `ip a|grep venet0:|grep inet|head -1|awk '{print $2}'| sed 's/\/[0-9]*//g'` `hostname` `hostname -s` >> /etc/hosts;
