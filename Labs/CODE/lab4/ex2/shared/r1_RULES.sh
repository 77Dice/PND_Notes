# Generated by xtables-save v1.8.2 on Tue Apr 12 10:41:54 2022
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:S1 - [0:0]
-A FORWARD -d 2001:db8:cafe:1::80/128 -j S1
-A S1 -p tcp -m multiport --dports 80,8080 -j ACCEPT
-A S1 -p tcp -m tcp --dport 22 -j ACCEPT
-A S1 -j REJECT --reject-with icmp6-port-unreachable
COMMIT
# Completed on Tue Apr 12 10:41:54 2022
