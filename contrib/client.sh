#!/usr/bin/bash

ssh -o ProxyCommand="websocat --binary ws://%h" $@
