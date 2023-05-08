Source
======

Source: ???
License: ???
template download: ???


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.

ssh $Host 'mkdir /etc/zabbix/scripts'
ssh $Host 'chgrp zabbix /etc/zabbix/scripts'

scp postfix-stats.sh root@$Host:/etc/zabbix/scripts/
ssh root@$Host 'chmod +x /etc/zabbix/scripts/postfix-stats.sh'

scp userparameter_postfix.conf root@$Host:/etc/zabbix/zabbix_agentd.d/userparameter_postfix.conf
ssh $Host 'chown root.zabbix /etc/zabbix/zabbix_agentd.d/userparameter_postfix.conf'

# restrictive access rights because of sudo:
ssh root@$Host 'chown root.zabbix /etc/zabbix/scripts/postfix-stats.sh'
ssh root@$Host 'chmod 750 /etc/zabbix/scripts/postfix-stats.sh'

scp zabbix-postfix-stats-sudoers $Host:/etc/sudoers.d/zabbix-postfix-stats-sudoers
# zabbix ALL = NOPASSWD: /etc/zabbix/scripts/postfix-stats.sh


ssh $Host 'systemctl restart zabbix-agent.service'
