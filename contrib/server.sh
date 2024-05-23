#!/usr/bin/bash

nginx

/usr/sbin/sshd

websocat --binary -E ws-l:127.0.0.1:8022 tcp:127.0.0.1:22
