#!/usr/bin/bash

set -x

# https://gist.github.com/cfra/752d6e761225fd5bf783b44abe30f707

socat TUN,tun-type=tap,tun-name=tunS,iff-up TCP-LISTEN:1234,bind=127.0.0.1,reuseaddr,forever,fork &
sleep 1
ip address add 10.0.42.2/24 dev tunS
ip link set tunS up
websocat -v --print-ping-rtts --ping-interval 6 --binary -E ws-l:0.0.0.0:80 tcp:127.0.0.1:1234
