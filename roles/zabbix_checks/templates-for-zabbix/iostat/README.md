Source
======

Source: https://github.com/tulnovdl/ZabbixIostatMonitoring
License: GPL3
template download: https://raw.githubusercontent.com/tulnovdl/ZabbixIostatMonitoring/main/zabbix_iostat_monitoring_template.yaml


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.


apt install sysstat jq
# sysstat 15.4.2 recommended

in config: /etc/zabbix/zabbix_agent.conf or /etc/zabbix/zabbix_agent2.conf :

AllowKey=system.run[*]

or more specific:
 
AllowKey=system.run[iostat*]


Since Zabbix 5.0.2 the EnableRemoteCommands agent parameter is:
   * deprecated by Zabbix agent
   * unsupported by Zabbix agent2
 https://www.zabbix.com/documentation/6.0/en/manual/config/items/restrict_checks
