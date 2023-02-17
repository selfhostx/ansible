#!/bin/bash

# get Postfix-metrics for monitoring-tools (like zabbix)
# print values:
# 0 to ... (acutal count)
# -1 when error (usually permission-issues)

function get_item ()
{
find /var/spool/postfix/$item -type f | wc -l
#amount=$(find /var/spool/postfix/$item -type f 2> /dev/null | wc -l)
#if [ ${PIPESTATUS[0]} -ne 0 ]; then
#if [ `echo "${PIPESTATUS[@]}" | tr -s ' ' + | bc` -ne 0 ]; then
#  amount="-1"
#fi
#echo "$amount"
}

function display_usage ()
{
  echo "empty or unsupported parameter, valid choices are: "
  echo "active"
  echo "deferred"
  echo "incoming"
  echo "maildrop"
  echo "queue"
}




# maildr

case "$1" in
active|deferred|incoming|maildrop)
  item="$1"
  get_item
  ;;
queue)
  # seems to work with unpriv users:
  mailq | grep -v "Mail queue is empty" | grep -c '^[0-9A-Z]'
  ;;
tempblocked)
  mailq | grep -c -e "IP address has been temporarily" -e "exceeded message" -e "blocked" -e "unsolicited mail" -e "prevents additional messages from being delivered" -e "reset-request" -e "block for spam" | grep -v "Requested"
  ;;
*)
  display_usage
  ;;
esac
