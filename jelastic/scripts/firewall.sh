
#!/bin/bash

iptables  -t nat -A PREROUTING -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 8743 
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 8743 -j ACCEPT
/etc/init.d/iptables save  >/dev/null 2>&1
