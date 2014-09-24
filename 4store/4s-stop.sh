#!/bin/bash
# stops ALL 4store-backend-processes and http-daemons, if --dev flag is given it also releases the port specified after the flag

# Processing flags; '--dev [PORT-NR]' is optional, but needs to be a pair
dev="false"

while [ $# -gt 0 ]
do
    if [ "$1" = "--dev" ]
    then
	dev="true"
	port=$2
	shift
	shift
    fi
done

# stop all 4store-processes
killall 4s-httpd
killall 4s-backend

# releases accessblock to port used by the 4store-http-daemon if '--dev'-Flag is specified
if [ "$dev" = "true" ]
then
    sudo iptables -D INPUT -p tcp --dport $port -s 127.0.0.1 -j ACCEPT
    sudo iptables -D INPUT -p tcp --dport $port -j DROP
fi