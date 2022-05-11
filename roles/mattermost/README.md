mattermost
==========

designed principles:
- mattermost has seperate data-directory to seperate code from data (symlinks are used)
  version upgrade possible (just increase the version-number, decrease might not work due db upgrades)
- nginx with custom mattermost config as reverse proxy in front of mattermost
- highly re-useable with template-override
- db creation is out-if-scope (see example playbook)

TODO: 
- Backup before installing new version?

Commands
--------


```
ansible-playbook mattermost.yml 
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

```
FIXME
```



License
-------

GPLv3



Author Information
------------------

Sven Holter
Stefan Schwarz
