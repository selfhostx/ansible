Source
======

Source: https://github.com/khony/zabbix-bacula/
License: ???
template download: https://raw.githubusercontent.com/khony/zabbix-bacula/master/templates/zbx_export_templates.xml


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.


create a sudo entry to execute script

/etc/sudoers.d/zabbix :
zabbix ALL=NOPASSWD: /etc/zabbix/scripts/bacula_discovery, /etc/zabbix/scripts/bacula_check_job

-> /etc/zabbix/zabbix_agentd.d/bacula.conf

UserParameter=BACULA.discovery,/usr/bin/sudo /etc/zabbix/scripts/bacula_discovery
UserParameter=BACULA.check[*],/usr/bin/sudo /etc/zabbix/scripts/bacula_check_job $1 $2 $3 $4

chown zabbix.zabbix /etc/zabbix/zabbix_agentd.d/bacula.conf

copy scripts/ to /etc/zabbix/scripts

mkdir /etc/zabbix/scripts
cd /etc/zabbix/scripts
wget https://raw.githubusercontent.com/khony/zabbix-bacula/master/scripts/bacula_check_job
wget https://raw.githubusercontent.com/khony/zabbix-bacula/master/scripts/bacula_discovery

chmod +x *

# for the access to /etc/bacula/bconsole.conf :
usermod -a -G bacula zabbix
