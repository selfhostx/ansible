#!/bin/bash
# source: https://github.com/cryptage21/wireguard-zabbix

interfaces()
{
interfaces=$(/usr/bin/wg show interfaces)
for int in ${interfaces[*]}
do
	ifaces="${ifaces},"'{"{#WGINTERFACE}":"'${int}'"}'
done
echo '{"data":['${ifaces#,}']}'
}

peers()
{
interfaces=$(/usr/bin/wg show all listen-port |awk '{print $1}')
for int in ${interfaces}
do
	for peer in $(/usr/bin/wg show ${int} peers | awk '{print $1}' | cut -c1-10 | tr '[:upper:]' '[:lower:]')
		do
			peers="${peers},"'{"{#PEER}":"'${peer}'","{#INTERFACE}":"'${int}'"}'
		done
done
echo '{"data":['${peers#,}']}'
}

case $1 in 
	INTERFACES)
		interfaces
		;;
	PEERS)
		peers
		;;
	*)
		echo "Usage: $(basename "$0") [PEERS | INTERFACES]"
		exit 1;
		;;
esac

exit 0
