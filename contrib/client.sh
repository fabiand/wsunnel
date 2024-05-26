#!/usr/bin/bash

set -x

# <host>:<port>
REMOTE=$1

socat TUN,tun-type=tap,tun-name=tunC,iff-up TCP-LISTEN:1235,bind=127.0.0.1 &
sleep 1
ip address add 10.0.42.15/24 dev tunC
websocat --binary ws://$REMOTE tcp:127.0.0.1:1235 &

if [[ -n "$2" ]];
then
  ping 10.0.42.2 -c 10
else
  ping 10.0.42.2
fi
