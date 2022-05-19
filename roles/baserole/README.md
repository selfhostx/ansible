Baserole features
=================

- package-management:
  - apt preferences (incl. proxy)
  - default packages
  - upgrade
  - add repositories
- DNS:
  - resolv.conf/glibc or systemd-resolved
  - FQDN (+reverse) 2DO (check if hostname --fqdn is not just hostname)
- SSHD configuration
- usermanagement (incl. authorized keys and sudo)
  - root
  - own users
- configs
  - bashrc
  - nano
  - vim
- groupmanagement
- sysctl settings
- systemd-journald settings
- machine-id regen (cloned systems)
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
