Source
======

Source: https://www.zabbix.com/integrations/mysql
License: ??? 
template download:
  https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/templates/db/mysql_agent/template_db_mysql.conf?at=refs%2Fheads%2Fmaster
  https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/templates/db/mysql_agent/template_db_mysql_agent.xml
current userparameters: https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/templates/db/mysql_agent/template_db_mysql.conf?at=refs%2Fheads%2Fmaster


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.


wget https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/templates/db/mysql_agent/template_db_mysql.conf?at=refs%2Fheads%2Fmaster -O /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

chown zabbix.zabbix /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
chmod 600 /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf


-> if the zabbix-agent does not use the defaults-file 
wendet, siehe extra angepasst Datei in diesem Verzeichnis (überall "--defaults-file=/var/lib/zabbix/.my.cnf" ergänzt)


login:
mysql --defaults-file=/root/.my.cnf -u root
oder
mysql -u root -p


# maybe "%" instead of "localhost" für global-login
CREATE USER 'zbx_monitor'@'localhost' IDENTIFIED BY '<password>';
GRANT USAGE,REPLICATION CLIENT,PROCESS,SHOW DATABASES,SHOW VIEW ON *.* TO 'zbx_monitor'@'localhost';

mkdir /var/lib/zabbix/
chown zabbix.zabbix /var/lib/zabbix/
chmod 700 /var/lib/zabbix/


edit: /var/lib/zabbix/.my.cnf

[client]
user=zbx_monitor
password=<password>

chown zabbix.zabbix /var/lib/zabbix/.my.cnf
chmod 600 /var/lib/zabbix/.my.cnf

TEST:
sudo -u zabbix mysqladmin --defaults-file=/var/lib/zabbix/.my.cnf -hlocalhost -P3306 ping
-> mysqld is alive

systemctl restart zabbix-agent.service
