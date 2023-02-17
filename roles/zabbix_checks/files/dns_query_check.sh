#!/bin/sh
# purpose of this script is to check a dns-wildcard entry:
# example:
# *.dnstest.mydomain.tld value: 1.2.3.4
#ask_wildcard="dnstest.mydomain.tld"
#ask_server="127.0.0.1"
#expected_answer="1.2.3.4"

# set -x

ask_wildcard="$1"
expected_answer="$2"
if [ -z "$3" ]
then
  ask_server="127.0.0.1"
else
  ask_server="$3"
fi

####################################################

Host=$(hostname --fqdn)
MAIL_RCPT=root

random_host=$(pwgen -1 --no-capitalize --no-numerals 8)
ask_host="$random_host.$ask_wildcard"

ip=$(dig $ask_host +short @$ask_server 2> /dev/null)

if [ "$ip" != "$expected_answer" ]; then
  echo 1
  # send mail:
  #  mail -s "** DNS not working on $Host **" $MAIL_RCPT <<EOF
  #  *** DNS-Query WARNING ***
  #  Server $ask_server is not really doing any real queries.
  #  expected answer for $ask_host: $expected_answer got: $ip
  #
  #  check is running on Host: $Host ($0)
  #EOF
else
  echo 0
fi
