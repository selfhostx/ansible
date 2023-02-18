#!/bin/bash
# Written By Nicole, transformed to Zabbix by Andre Schild
# Any Comments or Questions please e-mail to andre@schild.ws
#
# Plugin Name: check_ipsec
# Version: 2.2
# Date: 2017/11/27 2.2 Removed test for gateway.txt file
# Date: 2016/11/01 2.1 Added support for ikev1 tunnels with strongswan
# Date: 2015/02/06 2.0 Added support for strongswan
#
#
# ------------Defining Variables------------
PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 2.0 $' | sed -e 's/[^0-9.]//g'`
#STRONG=`$IPSECBIN --version |grep strongSwan | wc -l`
DOWN=""
# ---------- Change to your needs ----------
PLUGINPATH="/root"
IPSECBIN="/usr/sbin/ipsec"
FPINGBIN="/usr/bin/fping"
# ping server in network on the other side of the tunnel
PINGIP=1		# ping yes or no (1/0)
USE_SUDO=0		# Run the ipsec command via sudo
SUDOBIN="/usr/bin/sudo"
# ------------------------------------------

if [ $USE_SUDO -eq 1 ];
then
    IPSECCMD="$SUDOBIN -- $IPSECBIN"
else
    IPSECCMD=$IPSECBIN
fi

# . $PROGPATH/utils.sh


# Testing availability of $IPSECBIN, $FPINGBIN 

if [ $# -eq 0 ];
then
   echo UNKNOWN - missing Arguments. Run check_ipsec --help
   exit $STATE_UNKNOWN
fi

test -e $IPSECBIN
if [ $? -ne 0 ];
then
	echo CRITICAL - $IPSECBIN not exist
	exit $STATE_CRITICAL
else
	STRONG=`$IPSECBIN --version |grep strongSwan | wc -l`
fi

if [ $PINGIP -eq 1 ]
then
	test -e $FPINGBIN
	if [ $? -ne 0 ];
	then
		echo CRITICAL - $FPINGBIN not exist
		exit $STATE_CRITICAL
	fi
fi

print_usage() {
        echo "Usage:"
        echo " $PROGNAME <tunnelname>"
        echo " $PROGNAME <ping-ip> <ping-src-ip>"
        echo " $PROGNAME <ping-ip> <ping-src-ip> rtt"
        echo " $PROGNAME --help"
        echo " $PROGNAME --version"
        echo " Created by Andre Schild, questions or problems e-mail andre@schild.ws"
		echo ""
}

print_help() {
        print_usage
        echo " Checks vpn connection status of an openswan or strongswan installation."
		echo ""
        echo " <tunnelname> Check if the given tunnel is active"
	echo " <ping-ip> <ping-src-ip> ping the remote IP via tunnel, using the given source IP address"
	echo " <ping-ip> <ping-src-ip> rtt ping the remote IP via tunnel, using the given source IP address, return round trip time"
		echo ""
        echo " --help"
		echo " -h"
        echo " prints this help screen"
		echo ""
        echo ""
}

check_tunnel() {

	if [[ "$STRONG" -eq "1" ]]
	then
	    eroutes=`$IPSECCMD status | grep -e "IPsec SA established" | grep -e "newest IPSEC" | wc -l`
	else
	    eroutes=`$IPSECCMD whack --status | grep -e "IPsec SA established" | grep -e "newest IPSEC" | wc -l`
	fi 

	
	if [[ "$eroutes" -eq "$2" ]]
	then
		echo "OK - All $2 tunnels are up an running"
		exit $STATE_OK
	elif [[ "$eroutes" -gt "$2" ]]
	then
		echo "WARNING - More than $2 ($eroutes) tunnels are up an running"
                exit $STATE_WARNING
	else
		echo "CRITICAL - Only $eroutes tunnels from $2 are up an running - $(location)"
		exit $STATE_CRITICAL
	fi
}


ping_tunnel() {

	IP_DEST="$1"
	IP_SRC="$2"

        alive=`$FPINGBIN $IP_DEST -S$IP_SRC -r 1 | grep alive | wc -l`

        if [[ "$alive" -eq "0" ]]
        then
            echo 0
        else
            echo 1
        fi
}


ping_tunnel_rtt() {

        IP_DEST="$1"
        IP_SRC="$2"

        rtt=`$FPINGBIN $IP_DEST -S$IP_SRC -r 1 -e`
        alive=`echo $rtt | grep alive | wc -l`

        if [[ "$alive" -eq "1" ]]
        then
             rtt_ms= echo $rtt | cut -d "(" -f2 | cut -d ")" -f1 | cut -d " " -f1
        fi
}




test_tunnel() {

	CONN="$1"
	if [[ "$STRONG" -eq "1" ]]
	then
	    tunneltest=`$IPSECCMD status $CONN | grep -e "ESTABLISHED" | wc -l`
	    if [[ "$tunneltest" -eq "0" ]]
    	    then
		tunneltest=`$IPSECCMD whack --status | grep -e "IPsec SA established" | grep -e "newest IPSEC" |grep -e "$CONN" | wc -l`
	    fi
	else
	    tunneltest=`$IPSECCMD whack --status | grep -e "IPsec SA established" | grep -e "newest IPSEC" |grep -e "$CONN" | wc -l`
	fi
	
	if [[ "$tunneltest" -eq "0" ]]
    then
	echo 0
    else
	echo 1
    fi
}


case "$1" in
--help)
        print_help
        exit $STATE_OK
        ;;
-h)
        print_help
        exit $STATE_OK
        ;;
*)
	if [ $# -eq 1 ]
	then
    	    test_tunnel $1
    	else
	    if [ $# -eq 2 ]
	    then
    		ping_tunnel $1 $2
    	    else
    	        if [ $# -eq 3 ]
		then
    		    ping_tunnel_rtt $1 $2
    		else
    		    print_help
    		fi
    	    fi
    	fi
        ;;

esac

