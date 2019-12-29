#!/bin/bash
iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -p tcp -m tcp --dport 22 -j DROP
