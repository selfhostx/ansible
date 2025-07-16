zabbix checks role
==================

role for installing userparameters and templates for common Linux environments

official zabbix-project already shares a lot of templates (https://github.com/zabbix/community-templates) but they require manual install.



Commands
--------

you need to enable certain checks on hosts first (group_vars, hosts_vars, inventory, ...) example: "zabbix_checks_dns_enable: true" then run:

```
ansible-playbook zabbix-checks.yml 
```


Requirements
------------

none


Role Variables
--------------

required:
```
FIXME
```
see defaults/main.yml for more variables


Example Playbook
----------------

see: playbooks/monitoring/zabbix-checks.yml

License
=======

GPL-3.0-or-later

Author Information
==================

Stefan Schwarz
