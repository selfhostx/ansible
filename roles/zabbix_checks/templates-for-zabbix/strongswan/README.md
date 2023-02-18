Source
======

Source: https://github.com/a-schild/zabbix-ipsec
License: MIT license 
template download: 


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does (when i implement it FIXME).


apt install fping


/etc/zabbix/ipsec.conf


{
    "data":[
        { "{#TUNNEL}":"nbiot","{#TARGETIP}":"80.187.254.129","{#SOURCEIP}":"46.4.4.179","{#RTT_TIME_WARN}":"80","{#RTT_TIME_ERR}":"150" },
        ]
}



upload Datei /etc/zabbix/zabbix_agentd.d/userparameter_ipsec.conf
chgrp zabbix /etc/zabbix/zabbix_agentd.d/userparameter_ipsec.conf
chmod +x /etc/zabbix/zabbix_agentd.d/userparameter_ipsec.conf

visudo -f /etc/sudoers.d/zabbix_ipsec

#Defaults:zabbix !requiretty
#Defaults:zabbix !syslog
zabbix ALL = (root) NOPASSWD: /etc/zabbix/ipsec.sh


wget -O /etc/zabbix/ipsec.sh https://raw.githubusercontent.com/a-schild/zabbix-ipsec/master/usr/local/lib/zabbix/externalscripts/check_ipsec.sh
chmod 750 /etc/zabbix/ipsec.sh


systemctl restart zabbix-agent.service
