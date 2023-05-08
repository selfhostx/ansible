Source
======

Source: https://github.com/omni-lchen/zabbix-tcp
  https://share.zabbix.com/operating-systems/linux/tcp-states
License: not stated in repo
Template download: https://raw.githubusercontent.com/omni-lchen/zabbix-tcp/master/Templates/Template_TCP_Stats.xml
  merged: https://github.com/omni-lchen/zabbix-tcp/pull/3

manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.

- import the TCP stats template to zabbix and link it to the zabbix host.
- copy the TCP stats script to the host in /usr/local/bin .
- copy TCP stats zabbix agent configuration to /etc/zabbix-agent/zabbix_agentd.d and restart zabbix agent.

needs command "ss" from "iproute2"-package

! hostname config in /etc/zabbix/zabbix_agentd.conf
