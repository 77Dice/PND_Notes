# preliminars - AMCE 21

1. remote as localhost x access on eudoram... (try it)
2. execute command : 
```bash
# ACME 21 --> 5021 + matricula
ssh -L 5021:100.90.0.$21$:1194 1605230@151.100.174.34 -p 80
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

> **SERVICES in INT-serv Network** --> DNS(udp-tcp 53) + SYSlog(udp-tcp 514 + tcp 6514) 

> **SERVICES outside INT-serv Net** --> webServer(tcp 80,443) + Proxy
> **HOSTS** --> DMZ + CLIENTs + SERVER net
 
--- against IP spoofing :: define rules with in/out interfaces; 
 make test from kali-client with IP of 100.100.6.0 - 2.0
### rule1

> **All the host** have to use as DNS resolver the internal DNS.
  - https://docs.netgate.com/pfsense/en/latest/services/dns/resolver-config.html

- rule x DNS traffic 53 from 100.100.1.2 IP addr. to Internal NET + DMZ.
#### internal FW
  - to DNS from DMZ + CLIENT
  - -A FORWARD -s 100.100.2.0/24 -d 100.100.1.2  -p udp --dport 53 -j ACCEPT
  - -A FORWARD -s 100.100.2.0/24 -d 100.100.1.2  -p tcp --dport 53 -j ACCEPT
  - -A FORWARD -s 100.100.6.0/24 -d 100.100.1.2  -p udp --dport 53 -j ACCEPT
  - -A FORWARD -s 100.100.6.0/24 -d 100.100.1.2  -p tcp --dport 53 -j ACCEPT

  - from DNS to DMZ + CLIENT  
  - -A FORWARD -s 100.100.1.2 -d 100.100.2.0/24 -p udp --sport 53 -j ACCEPT
  - -A FORWARD -s 100.100.1.2 -d 100.100.2.0/24 -p tcp --sport 53 -j ACCEPT
  - -A FORWARD -s 100.100.1.2 -d 100.100.6.0/24 -p udp --sport 53 -j ACCEPT
  - -A FORWARD -s 100.100.1.2 -d 100.100.6.0/24 -p tcp --sport 53 -j ACCEPT
   
#### MAIN FW  
  - traffic DMZ--DNS on main firewall   
  - -A FORWARD -s 100.100.6.0/24 -d 100.100.1.2  -p udp --dport 53 -j ACCEPT
  - -A FORWARD -s 100.100.6.0/24 -d 100.100.1.2  -p tcp --dport 53 -j ACCEPT
  - -A FORWARD -s 100.100.1.2 -d 100.100.6.0/24 -p udp --sport 53 -j ACCEPT
  - -A FORWARD -s 100.100.1.2 -d 100.100.6.0/24 -p tcp --sport 53 -j ACCEPT


### rule2

> Only the webserver service provided in the DMZ has to be accessible from the Internet

#### MAIN FW:
  - accept incoming traffic on HTTP + HTTPS for webserver and outgoing traffic directed to all networks
    - -A FORWARD -d 100.100.6.2 -p tcp -m multiport --dports 80,443 -j ACCEPT
    - -A FORWARD -s 100.100.6.2 -j ACCEPT 

### rule3

> The *proxy service* provided in the DMZ has to be **accessible only from the hosts of the Acme network.** However, the proxy needs **internet access** (see below, section Services of the ACME co.)
#### MAIN FW:
1.  traffic from/to Proxy/Internet ; allow outgoing traffic and new connections but don't allow NEW connection directed to Proxy
    - -A FORWARD -s 100.100.6.3 -o(ethINTERNET) -j ACCEPT
    - -A FORWARD -s(ethINTERNET) -d 100.100.6.3 -p tcp -m state ! --state NEW -j ACCEPT
2.  traffic from/to Proxy/Bridge ; 
      - -A FORWARD -i(ethBRIDGE) -d(100.100.6.3) -j ACCEPT 
      - -A FORWARD -s(100.100.6.3) -o(ethBRIDGE) -j ACCEPT  

#### Internal FW:
- -A FORWARD -s 100.100.6.3 -d 100.100.2.0/24 -j ACCEPT
- -A FORWARD -s 100.100.6.3 -d 100.100.1.0/24 -j ACCEPT
- -A FORWARD -s 100.100.2.0/24 -d 100.100.6.3 -j ACCEPT
- -A FORWARD -s 100.100.1.0/24 -d 100.100.6.3 -j ACCEPT

- **protocol/port for connection Proxy/internal-clients ??**
  
### rule 4 

> **All the services** provided by hosts in the Internal server network have to be accessible **only by** Client network and DMZ hosts

- DNS already on rule 1 ; for SYSlog same structure as rule 1 with :
  - instead of 100.100.1.2 -> 1.3
  - instead of --d/sport 53 -> 514 + 6514
  
- **which ports ? which protocols allowed ??** 

### rule 5 
> Anything that is not specifically allowed **has to be denied**
 
 - -P FORWARD DROP

---------------------------------------
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



------------------------------

- -A FORWARD -i(internet) ! -d(WEBSrv) -p tcp/udp -m state ! --state NEW -j ACCEPT
  