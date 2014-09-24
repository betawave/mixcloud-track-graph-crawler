#!/bin/bash
# starts a 4store backend and http-daemon whose name should be specified after the '-n'-Flag and whose port should be specified after the '-p'-Flag

# Processing flags; '-n' and '-p' are mandatory, '--dev' is optional
dev="false"

while [ $# -gt 0 ]
do
    if [ "$1" = "-n" ]
    then
	name=$2
	shift
	shift
    fi
    if [ "$1" = "-p" ]
    then
	port=$2
	shift
	shift
    fi
    if [ "$1" = "--dev" ]
    then
	dev="true"
	shift
    fi
done

# starts 4store-processes
4s-backend $name
4s-httpd -p $port $name

# blocks foreign access to the port the http-daemon listnes on if '--dev'-flag is given
if [ "$dev" = "true" ]
then
    sudo iptables -A INPUT -p tcp --dport $port -s 127.0.0.1 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport $port -j DROP
fi