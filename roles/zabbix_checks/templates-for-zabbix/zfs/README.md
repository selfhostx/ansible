Source
======

Source: https://github.com/Cosium/zabbix_zfs-on-linux
License: MIT license
template download: https://raw.githubusercontent.com/stefanux/zabbix_zfs-on-linux/master/template/zol_template.xml


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does.


Create the needed regular expressions: Administration -> General -> Regular expressions 

Name: ZFS fileset
Expression type: Character string included
Expression: /


