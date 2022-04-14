# preliminars - AMCE 21

1. remote as localhost x access on eudoram... (try it)
2. execute command : 
```bash
# ACME 21 --> 5021 + matricula
ssh -L $5021$:100.90.0.$21$:1194 $1605230$@151.100.174.34 -p 80
# use password sent by email
### --> PORT FORWARDING  : all traffic for local port 5021 will be directed to host 100.90.0.21.... but all will be sent using ssh tunnel by our server . 
... for now is not working !!!

but i can still connect to the remote portal.
```
- isp + fantastic coffe. not access allowed
- for make some examples needs to be active :
  - isp + routers + dns + external client
- DO NOT ACCESS FIREWALLS BY CONSOLE...
- ACCESS FIREWALLS VIA WEB CONNECTIONS -> client kali -> 100.100.4.1 (root/opnsense)
- try SPICE remote control
  - xrandr --output Virtual-1 (--auto) --mode 1920x1080 --> INSIDE KALI TERMINAL!!
- services will be CONFIGURED WITH THE PROF!!
-  number 4 : what he wants ?? 
-  test : automated or manual

BOTH IPv4 - IPv6!!!!!

IPV6 + servers  WILL BE DONE LATER  ... FOR  NOW RULES ONLY for IPv4!!!!!

# rules 

- All the host have to use as DNS resolver the internal DNS.
  - https://docs.netgate.com/pfsense/en/latest/services/dns/resolver-config.html
- Only the webserver service provided in the DMZ has to be accessible from the Internet
  - if directed to other NET, allow only packets NOT NEW + if directed to DMZ skip this rule.
  - -A FORWARD -i(internet) ! -d(WEBSrv) -p tcp/udp -m state ! --state NEW -j ACCEPT
- The proxy service provided in the DMZ has to be accessible only from the hosts of the Acme network. However, the proxy needs internet access (see below, section Services of the ACME co.)
  - -A FORWARD -s (Proxy) -o(OUTinternet) -j ACCEPT
  - -A FORWARD -s(OUTint.) -d(Proxy) -j ACCEPT ( da mettere dopo !NEW)
  - -A FORWARD -s (intern) -d (Proxy) -j ACCEPT 
  - -A FORWARD -s(Proxy) -d(intern) -j ACCEPT  (protocol type??)
- All the services provided by hosts in the Internal server network have to be accessible only by Client network and DMZ hosts
  - internal FW : 
    - -A FORWARD -i(srvINT) -d(intNET+DMZNet) -j ACCEPT 
    - -A FORWARD -i(srvINT) -d(intNET+DMZNet) -j ACCEPT 
      - ma serve ogni volta definire le 2 direzioni ??
  - MAIN FW
    - -A FW -s(SrvINT) -d(DMZNet) -j ACCEPT
- Anything that is not specifically allowed has to be denied.
  - -P FW DROP
- All the hosts (but the Client network hosts) have to use the syslog service on the Log server (syslog).
  - ????
- All the host of the network have to be managed via ssh only from hosts within the Client network.
  - ACCEPT SSH only if SOURCE ADD is inside INternalNet
    - -A FW -s(intHosts) -p tcp -dport 22 -j ACCEPT 
- All the Client network hosts have to only access external web services (http/https)
  - 
- Any packet received by the Main Firewall on port 65432 should be redirected to port 80 of the fantasticcoffee host.
  - REDIRECT PORT - FORWARDING 
    - NAT TABLE x REDIRECT -t PREROUTING ....
    - https://www.cyberciti.biz/faq/linux-port-redirection-with-iptables/
- The firewalls should protect against IP address spoofing.
  - come ??
- The rate of ICMP echo request packets should be limited to 10 Kbit/s.
  - https://superuser.com/questions/1006066/iptables-rules-to-rate-limit-icmp-ping-traffic-to-5-packets-per-second
