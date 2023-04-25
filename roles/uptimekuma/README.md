uptime kuma
===========

designed principles:
- NOT using docker since i wanted to go dualstack IPv4/IPv6
- using nvm which can provide a switchable nodejs-version, reason: uptime kuma needs current versions (Node.js >= 14 and npm >= 7) which is not available in distro-packages in Debian/Ubuntu LTS
- nginx with reverse proxy config in front of uptime kuma


Commands
--------


```
ansible-playbook uptimekuma.yml 
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

Stefan Schwarz
