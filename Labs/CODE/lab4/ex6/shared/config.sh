# Generated by xtables-save v1.8.2 on Mon May  9 21:58:59 2022
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A PREROUTING -i eth2 -p tcp -m tcp --dport 22 -j DNAT --to-destination 192.168.10.2:22
-A PREROUTING -i eth2 -p tcp -m tcp --dport 2222 -j DNAT --to-destination 192.168.10.18:2222
-A PREROUTING -i eth2 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.10.18:8080
-A PREROUTING -i eth2 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.10.22:80
-A POSTROUTING -o eth2 -j MASQUERADE
COMMIT
# Completed on Mon May  9 21:58:59 2022
# Generated by xtables-save v1.8.2 on Mon May  9 21:58:59 2022
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -p tcp -m multiport ! --dports 22,80,443,2222,8080,8088 -j REJECT --reject-with icmp-port-unreachable
COMMIT
# Completed on Mon May  9 21:58:59 2022