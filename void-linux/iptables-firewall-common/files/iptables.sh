#!/bin/sh
# n0
# File: iptables.sh
# Description: default iptables configuration script with default log and drop
# a110w

##############################################################################

IPTABLES=/usr/bin/iptables
INT_INTF=eth0

### flush existing rules and set chain policy setting to DROP
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

##############################################################################
# INPUT chain 
echo "[+] Setting up INPUT chain..."

# state tracking rules
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "[DROP INPUT INVALID] " --log-ip-options --log-tcp-options
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ACCEPT rules
# accept inbound ssh
$IPTABLES -A INPUT -i $INT_INTF -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
# accept inbound ping, icmp type 8
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# default INPUT LOG rule
$IPTABLES -A INPUT ! -i lo -j LOG --log-prefix "[DROP INPUT] " --log-ip-options --log-tcp-options

# make sure that loopback traffic is accepted
$IPTABLES -A INPUT -i lo -j ACCEPT

##############################################################################
# OUTPUT chain
echo "[+] Setting up OUTPUT chain..."

### state tracking rules
$IPTABLES -A OUTPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "[DROP OUTPUT INVALID] " --log-ip-options --log-tcp-options
$IPTABLES -A OUTPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

### ACCEPT rules for allowing connections out
# allow outbound ssh
$IPTABLES -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound http
$IPTABLES -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound gopher
$IPTABLES -A OUTPUT -p tcp --dport 70 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound https
$IPTABLES -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound irc
$IPTABLES -A OUTPUT -p tcp --dport 6697 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound irc encrypted
$IPTABLES -A OUTPUT -p tcp --dport 6667 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound proxy
$IPTABLES -A OUTPUT -p tcp --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound dns
$IPTABLES -A OUTPUT -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound dns
$IPTABLES -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound ntp
$IPTABLES -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound dhcp
$IPTABLES -A OUTPUT -p udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound dhcp
$IPTABLES -A OUTPUT -p udp --dport 68 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound wireguard
$IPTABLES -A OUTPUT -p udp --dport 51820 -m conntrack --ctstate NEW -j ACCEPT
# allow outbound ping, icmp type 8
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

### default OUTPUT LOG rule
$IPTABLES -A OUTPUT ! -o lo -j LOG --log-prefix "[DROP OUTPUT] " --log-ip-options --log-tcp-options

### make sure that loopback traffic is accepted
$IPTABLES -A OUTPUT -o lo -j ACCEPT

exit
##############################################################################
# EOF
