Source
======

Source: https://github.com/romantico88/jitsi_videobridge_zabbix_stats
License: GPLv3
template download: https://raw.githubusercontent.com/romantico88/jitsi_videobridge_zabbix_stats/master/jitsi_videobridge_stats_zabbix_template.xml


manual install
==============

disclaimer: might be outdated, just for reference, these are the steps ansible does (when implemented FIXME).


- import template
- macro auf dem Host einrichten (Configuration -> Host -> Macro):

{$JITSI_MEET_HOST} -> FQDN or IP of Prosody XMPP Server
{$JITSI_COLIBRI_HOST} -> IP/FQDN of Jitsi Videobridge
