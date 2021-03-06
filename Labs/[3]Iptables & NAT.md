# Iptables Fundamentals
- [Netfilter](https://it.wikipedia.org/wiki/Netfilter) : linux kernel framework that provides hook handling for intercepting & manipulating network packets
- [Hooks](https://en.wikipedia.org/wiki/Hooking) : entities (like modules) that allow packets `manipulation` during their traversing
  -  when intercepted by there hooks the IP packet is verified against a given set of `matching rules` and processed by an `action` configured by the user  
- [Iptables](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html): Userspace level configurator 
  - *order of matching rules is important*
  - packets fates depend on the *first matching rule*
  - If no match the *default policy will be applied*
  - every chain has its *default policy* 
- [Iptables_book](https://book.huihoo.com/iptables-tutorial/book1.htm)
- [ip6tables_man](https://linux.die.net/man/8/ip6tables)

 
> ***TABLES** (operation over a packet) as set of **CHAINS** (how packets are elaborated)(queues) as set of **RULES**(match+action);*

## built-in tables 

each table defines a different kind of operation that can be perform over the packets 

- **filter** => filtering of packets : allow or block packets (accept/drop), every packet pass through this table
  - (INPUT / OUTPUT / FORWARD)
  - FORWARD chain is accessible only if machine is configured as router ( net.ipvX.ip_forward = 1 in /etc/sysctl.conf )

- **nat** => network address-port translation (SNAT/DNAT/MASQUERADE) : the *first packet* of a connection pass through this table then its result define behavior of next packets belonging to the same connection
  - (PRE_ROUTING / POST_ROUTING / OUTPUT)
  - special targets (DNAT / SNAT / MASQUERADE / REDIRECT)
- **mangle** => packet header modification (QoS), every packet pass through this table and contain all predefined chains
  - (PRE_ROUTING / POST_ROUTING / INPUT / OUTPUT / FORWARD )
- **raw** => avoid connection tracking (exceptions to conntracking) has **highest priority** over tables
  - (PRE_ROUTING / OUTPUT)

## built-in chains

- MANGLE > NAT > FILTER
- RAW > MANGLE

> ![picture 1](../images/757f07dd756b276a90b3bd92a17b96a140eb2ed35cdd70c5e495ec8306c1f753.png)  

Every packet pass through a set of hook-chains of multiple tables, each rule inside tables check a match. If match, other rules will be ignored


> ![picture 2](../images/076443cd74e3f0e366e1f477ceb76d6fca88ca3e73a10bed722cc2e5d2544463.png)  

## Iptables Flow

- local generated packets : 
  - Local Process -> OUTPUT -> POST_ROUTING -> NET
- Forwarded Packets :
  -  NET -> PRE_ROUTING -> FORWARD -> POST_ROUTING -> NET 
- Locally Addressed packets :
  -  NET -> PRE_ROUTING -> INPUT -> Local Process

## build-in rules

> <center>[Match + target]</center>
- **Match** : specification of the packet processed, a `special condition` within the packet that must be true (or false)
  - [GENERIC_mtc](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#GENERICMATCHES) : always available, *whatever* the protocol or extension we are working on
  - [IMPLICIT_mtc](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#IMPLICITMATCHES) : three types of implicit matches for three different protocols(TCP\UDP\ICMP). These are **unique criteria** available only for those protocol packets 
    - ... -p --protocol *tcp | udp | icmp* [imp_mtc] ...
  - [EXPLICIT_mtc](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#EXPLICITMATCHES) : have to be specifically loaded with the **-m or --match** option as extension module 
    - ... -m *addrtype | state | multiport | conntrack* [exp_mtc]... 
- **Target** : how manipulate the packet matching the rule, what Action to perform 

|**Target**|*how manipulate the packet matching the rule : what Action to perform*|
|--|--|
|ACCEPT| result depends on the current chain in the current table|
  | DROP | delete without sent back NACK |
  | QUEUE |  send packets to upper layers programs and applications|
  | RETURN | packet go to default policy of current chain, if sub-chain then travel through superior chain
  | REJECT | equal to DROP + send back ICMP error (**only** for filter table and its chains) 
  | LOG | logging packets, debugging of rules if used instead of DROP ([syslogd](https://linux.die.net/man/8/syslogd))
  | DNAT | (--to-destination) override IP destination address of packet and *all subsequent packets in the same stream* (**only** for NAT table and PRE_ROUTING chain) *"`OUTPUT` chain is possible but `not used`"* 
  | SNAT | (--to-source) override IP source address of packet, used when multiple hosts share same Public IP Address (**only** for NAT table and POST_ROUTING chain)
  | MASQUERADE | as SNAT but for dynamically assigned IP connections, *we set the IP address used on a specific network interface instead of the (--to-source) option* (**only** for NAT table and POST_ROUTING chain)
  | ... | [other_TARGETS](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#TARGETS)

## User defined chains 

- It's possible to specify a *jump rule* to a different user chain **within the same table**

> ![picture 2](../images/user_chains.jpg)  

- policy in not applied to user defined chains; they simply jump back to the next rule in the main chain

## iptables logging 

**Target** -> LOG 
- `non-terminating target` -> matching packets continue to the next rule
 
When the rule is set the linux kernel will print some information on all matching packets via the *kernel log*

- it can be then read with dmegs or [syslogd(8)](https://linux.die.net/man/8/syslogd)

```bash 
# specifies type of log (emerg, alert, crit, err, warning, notice, info, debug)
--log-level lv 
# add further information to the front of all messages produced by the logging action
--log-prefix pfx 
```
- examples:
```bash
# Log forward packets
$ iptables -A FORWARD -p tcp -j LOG --log-level info --log-prefix "Forward INFO"

# Log and drop invalid packets
$ iptables -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "Invalid packet"

$ iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
```
# Stateful packet filtering 

## Connection Tracking machine 
> [The state machine](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#STATEMACHINE) is the name of the *connection tracking machine* inside Netfilter framework. Used **to know the state of a specific connection**

- Firewalls implementing this are **stateful** :
  - packets can be related (group by) to their connection so it's possible to define rules based on the common relation of packets
  - NAT table use this info to apply action at packets of the same connection
- packets are related to tracked connections in [*user-land states*](https://book.huihoo.com/iptables-tutorial/x4342.htm) with *state match extension* :
  - Flows : [TCP](https://book.huihoo.com/iptables-tutorial/x4436.htm) - [UDP](https://book.huihoo.com/iptables-tutorial/x4596.htm) - [ICMP](https://book.huihoo.com/iptables-tutorial/x4634.htm)
  - **-m state --state [s]** 

|[s]|packet is ...|
|--|--|
|NEW |start of a new\un-established connection|
|ESTABLISHED |part of a connection already registered in the kernel or established |
|RELATED|start of new connection created by an older established one |
| INVALID| can't be identified or that it does not have any state(ALWAYS DROP) |
| UNTRACKED | marked within the RAW table with the NOTRACK target | 
  
- [Conntrack match](https://book.huihoo.com/iptables-tutorial/x6330.htm#CONNTRACKMATCH) is an extended version of the state match 
  - **-m conntrack [option]**
- [*/proc/net/ip_conntrack*](https://book.huihoo.com/iptables-tutorial/x4273.htm) : list of current entries in conntrack database, all info maintained by the module **to know in which state a specific connection is**

# Commands & Syntax
> *$ iptables <span style="color:red"> [command] [chain] </span> [table] <span style="color:blue">[match]</span>
<span style="color:green">[target/jump]</span>*
> - $ iptables <span style="color:red"> -A POSTROUTING </span> -t nat <span style="color:blue">-o eth0 </span> <span style="color:green">-j MASQUERADE </span>

- tables -> chains -> rules -> target -> action || jump to  different chain
- default table --> filter table  
- tables as small letters // chains as CAPITAL LETTERS
- commands as CAPITAL LETTERS // option as small letters

|-L options | --list  | 
|--|--|
|-v | verbose|
|-n | numerical values, **no name resolv** |
|--line-numbers | show rule number|
|-L -v -f filter | show **number** of packets **matched** by the rule |
|**[Cmds+Options_tutorial](https://book.huihoo.com/iptables-tutorial/x5245.htm)**|**[Jump to other Chains_example](https://www.frozentux.net/iptables-tutorial/chunkyhtml/c3965.html)**|

```bash
rule -> [match] + -j [target]

# append / delete / insert / replace rules
iptables [-t table] {-A | -D} chain rule
iptables [-t table] -D chain rule_number
iptables [-t table] -I chain [rule_number] rule
iptables [-t table] -R chain rule_number rule

# list / flush rules
iptables -L -n -v --line-numbers
iptables [-t table] {-L|-F} chain

# set policy / new / delete(empty-ONLY) / rename chain
iptables [-t table] -P chain new_policy_target
iptables [-t table] {-N|-X} chain
iptables [-t table] -E old_chain new_chain_name
```
## common switches

|Useful iptables|command switches|
|--|--|
-t table |Specifies the table (filter if not given)
-j target |Jump to the target (it can be another chain)
-A chain |Append a rule to the specified chain
-p --protocol [prt] | Match the protocol type
-s --src [ip-address] |Match the source IP address
-d --dst [ip-address] |Match the destination IP address
-i --in-interface [eth-name] |Match input interface (from which the packet enters)
-o --out-interface [eth-name] |Match output interface (on which the packet exits)
! (==not) |Used to negate the match. Can be used with many flags, Example: all the source addresses but a specific one **-s ! ip_address**
-f |Match fragments which are not the first of a packet

|--|--|
|--|--|
-p tcp --sport port |Match the tcp source port
-p tcp --dport port |Match the tcp destination port
-p udp --sport port |Match the udp source port
-p udp --dport port |Match the udp destination port
-p icmp --icmp-type type |Match specific ICMP [packet types](https://book.huihoo.com/iptables-tutorial/a12854.htm)
|-p icmpv6 --icmpv6-type type|ip6tables-[icmpv6](https://it.wikipedia.org/wiki/ICMPv6) version|
-m module |Uses an extension module
-m state --state s |Enable **connection tracking**, Match a packet which is in a specific state
-p [ptc] -m multiport --xport port | Enable specification of several ports with one single rule
|-m addrtype --src/dst-type (typ)|Match IP address : UNICAST,MULTICAST,BROADCAST|

|--|--|
|--|--|
--syn |Match packets which start a TCP connection, It is equivalent to --tcp-flags SYN,RST,ACK SYN
-n |Used to avoid name substitution for IP hosts and port
-m conntrack -ctstate... | Enable connection tracking (superset of state)
-m mac --mac-source |Match packets with a specific source MAC address
-m limit |Limit the number of packets for a specific time period (--limit and --limit-burst) **iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT**

## create,save rule_set
- `iptables_rules.sh`
```bash 
#!/bin/bash
# flush (clean) the filter table
iptables -t filter -F
# allow only service XX
iptables ...
------------------------
# built-in commands (legacy)
iptables-legacy-save > iptables_rules.sh
iptables-legacy-restore < iptables_rules.sh
```

# Lab4 Activity
- add **alias** makes rules easier 
```bash
  echo 192.168.10.2 local_host >> /etc/hosts
  echo 2001:db8:cafe:2::2 local6_host >> /etc/hosts
```
- after starting the lab on host machine 
```bash
# add route to VM enviroment
  sudo ip route add 192.168.100.0/24 via 192.168.10.1 dev veth0
# Ipv6 case
  sudo ip -6 route add 2001:db8:cafe:1::/64 via 2001:db8:cafe:2::1 dev veth0
```
- on VM in order to reach outside network they need default route
```bash
  ip -6 route add default via fe80::1 dev eth0
```
- remember to save your configuration **on shared** folder 
```bash
  iptables-save > /shared/r1_RULES.sh
  ip6tables-save > /shared/r1_RULES.sh
```
- visualize **# of packets** matched by your rules
```bash
  iptables -L -v -f filter
  ip6tables -nvL
```
- how get **HTTP pages** in IPv6
```bash
$ wget IPv6_alias
$ wget http://[IPv6_address]:port
```

### EX1,2

> GOAL : Allow HTTP traffic to s1 only 

> GOAL : do the same with IPv6 and `ip6tables`

- create sub-chain for destination traffic towards s1 ONLY
- `iptables backup file` :
```bash
-N S1
-A FORWARD -d 192.168.100.80/32 -j S1
-A S1 -p tcp -m multiport --dports 80,8080 -j ACCEPT
##-A S1 -p tcp -m tcp --dport 22 -j ACCEPT
-A S1 -j REJECT --reject-with icmp-port-unreachable
```

### EX3

> GOAL : implement security policy below
- Use both IPv4 and IPv6
- test your policy from the isp machine (or local-host)
1. Internal Network (eth2)
    - Your internal pcs may freely access any Web service, anywhere, on ports **80 and 443**, but only **if they initiate the connection themselves** (i.e. they are allowed to browse the Web)
    - **No one outside** the internal lan **can initiate** connections to internal lan, on any port
    - Internal users **can access** the Web servers and mail servers **in DMZ via SSH**, too
    - They can also **use SSH** to reach **any host** on the Internet.
    - However, hosts **in DMZ** can only be contacted **on port 22 by** hosts in the **internal lan**
2. DMZ Network (eth1)
   - **Everyone**, including the Internet, can access Web (both ports) and mail in DMZ to access their main functions **and for ping**
   - However, **no host** in DMZ **can initiate connections** anywhere else
- order of rules is important
```bash
# internal to ... 80,334
-A FORWARD -s internalV6/64 (-i eth2) -p tcp -m multiport --dports 80,443 -j ACCEPT

# --> flip : cannot accept NEW packets directed to internal Lan
-A FORWARD -d internalV6/64 (-o eth2) -p tcp -m state ! --state NEW -j ACCEPT
###-A FORWARD -d internalV6/64 (-o eth2) -p icmpv6 ! --icmpv6-type 128 -j ACCEPT

# ping, all packets except for 128 from DMZ (-p icmp)
-A FORWARD -d DMZ/64 (-o eth1) -p icmpv6  -j ACCEPT # verso DMZ ALL ICMP PACKETS
-A FORWARD  (-i eth1) -p icmpv6 ! --icmpv6-type (echo-request --> 128) -j ACCEPT

# DMZ : no new connections
-A FORWARD -s DMZ/64 (-i eth1) -p tcp -m state ! --state NEW -j ACCEPT

# DMZ services 
-A FORWARD -d DMZ/64 (-o eth1) -p tcp -m multiport --dports 80,443,25 -j ACCEPT

# ssh bridge internal-DMZ
-A FORWARD -s internalV6/64 (-i eth2) -d DMZ/64 (-o eth1) -p tcp --dport 22 -j ACCEPT

-P FORWARD DROP
```
### EX4

> GOAL : masquerade all traffic
- if we try to ping or request a page from internal we don't receive any reply message
- that's because pc has *private address* and this is **not Routable** so reply never comes back
- this is because the **source address** used is **not routable** 
```bash
# eth1 is external interface
$ iptables -t NAT -A POSTROUTING -o eth1 -j MASQUERADE
```
- SNAT : router **has routable address** so It  needs to change source address and perform requests for private clients 

> Remember that with SNAT only : external hosts **cannot reach private network** or make any requests/connections

### EX5

> GOAL : make reachable internal Services via DNAT
- "when you have a host running your web server inside a LAN, but no real IP to give it that will work on the Internet"
- we want **to reach internal hosts of LAN** via **DNAT -> port forwarding**
```bash
# ssh for pc1
$ iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 22 -j NAT --to-destination 192.168.10.22:22
# http for s1
$ iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j NAT --to-destination 192.168.10.18:80
```
- now external hosts needs to make requests **directed to natting router**; they will be forwarded to private hosts
- No need to use SNAT in this case : rule will be *applied to all related packets* 

### EX6

> GOAL : config. portforwarding for multiple ports and block traffic on other ports
```bash
# eth2 is external interface
-t nat -A POSTROUTING -o eth2 -j MASQUERADE
# same structure for 80,8080,443,2222 ,22,8088
-t nat -A PREROUTING -i eth2 -p tcp --dport 22 -j DNAT --to-destination s1:22

-A FORWARD -p tcp -m multiport ! --dports 22,80,443,2222,8080,8088 -j REJECT
```
### EX7

> GOAL : Make fw1 to be a transparent firewall
- as a transparent bridge we can monitor/modulate traffic without create 2 separated networks
- firewall is not exposed on the network but **has Link-Local Addr**
```bash
brctl addbr br0
brctl addif br0 eth0
brctl addif br0 eth1
ip link set br0 up
```
> [brctl_man](https://linux.die.net/man/8/brctl)