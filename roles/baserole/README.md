Purpose and principles
======================

- packages
  - apt preferences (incl. proxy)
  - default packages
  - upgrade
  - add repositories
- DNS
  - resolv.conf/glibc or systemd-resolved
  - FQDN (+reverse) 2DO (check if hostname --fqdn is not just hostname)
- SSHD-config
- usermanagement (incl. authorized keys and sudo)
  - root
  - own users
  - configs
- groupmanagement
- SSHD-Config
- sysctl settings
- NTP systemd-timesyncd

2DO
===

- networkconfig (template)
- remove netplan? -> playbook
- ntp -> chrony?

Requirements
============

minimum ansible version: 2.10


Dependencies
============

None.


License
============

GPL-3.0-or-later


Author Information
==================

selfhostix
