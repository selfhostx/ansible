#!/bin/bash

# Date:                 22/08/2016
# Author:               Long Chen
# Description:          A script to send TCP stats to zabbix server by using zabbix sender
# Requires:             Zabbix Sender

# Get TCP socket states by using ss command
get_TCP_socket_states(){
ss -ant | grep -v State | awk '{print $1}' | tr '[:upper:]' '[:lower:]' | awk 'BEGIN {\
s["close-wait"]=0;\
s["estab"]=0;\
s["fin-wait-1"]=0;\
s["fin-wait-2"]=0;\
s["last-ack"]=0;\
s["syn-recv"]=0;\
s["syn-sent"]=0;\
s["time-wait"]=0} \
{s[$1]++} END \
{for (i in s) {print "- tcp.socket."i"", s[i]}}'
}

# Get TCP stats by using netstat command
get_TCP_conn_stats(){
netstat -st |sed -n '/Tcp:/,+10p' | grep -v "Tcp:" | sed 's/^    //g' | awk '{a[NR]=$0"  "$1} END {host="-"; for (i in a) {\
sub (/^.* active connections openings /, "tcp.conn.active.opens", a[i]); \
sub (/^.* passive connection openings /, "tcp.conn.passive.opens", a[i]); \
sub (/^.* failed connection attempts /, "tcp.conn.failed.attempts", a[i]); \
sub (/^.* resets sent /, "tcp.conn.resets.sent", a[i]); \
sub (/^.* connection resets received /, "tcp.conn.resets.recv", a[i]); \
sub (/^.* connections established /, "tcp.conn.estab", a[i]); \
sub (/^.* segments received /, "tcp.seg.recv", a[i]); \
sub (/^.* segments send out /, "tcp.seg.send", a[i]); \
sub (/^.* segments retransmited /, "tcp.seg.retrans", a[i]); \
sub (/^.* bad segments received. /, "tcp.seg.bad", a[i]); \
print host, a[i]}}'
}

# Send the results to zabbix server by using zabbix sender
result=$((get_TCP_socket_states; get_TCP_conn_stats) | /usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -i - 2>&1)
response=$(echo "$result" | awk -F ';' '$1 ~ /^info/ && match($1,/[0-9].*$/) {sum+=substr($1,RSTART,RLENGTH)} END {print sum}')
if [ -n "$response" ]; then
        echo "$response"
else
        echo "$result"
fi