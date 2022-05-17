# Network Eavesdropping/Sniffing 

> GOAL : *capture packets transmitted by other's nodes through the network and analyze it in search of sensitive information*([Sniffing](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing.htm)) 
> - *Passive Attack* type
> - all clear data *exchanged by unsafe protocols* : **without encryption**
>   - *HTTP, SMTP, POP, FTP, IMAP, DNS...*

> Tools $\rightarrowtail$ [Network Sniffers](https://www.tutorialspoint.com/ethical_hacking/ethical_hacking_sniffing_tools.htm) + protocol decoders or stream reassembling

## What does it require?

- NIC in [Promiscuous mode](/Labs/%5B1%5DNetworking%20101%2Bscript.md#Network%20Traffic%20Monitoring) : pass all the observable traffic without discrimination to the CPU
- Sniffer placed *along the path* or the `same Broadcast domain`
  - in Non-switched LANs
    - networks with HUBs
  - in Switched LANs
    - by flooding with large amount frames that **breaks switch segmentation** ([MAC flooding Attack](https://en.wikipedia.org/wiki/MAC_flooding))
    - by **redirect the traffic** from one port to another ([ARP spoofing Attack](https://en.wikipedia.org/wiki/ARP_spoofing) - MITM Attack)
  - in Wireless LANs 
    - if **no or weak encryption is used** : [WEP/WPA1,2](https://inis.iaea.org/collection/NCLCollectionStore/_Public/46/130/46130069.pdf)

## How Break Switch segmentation mechanism?

### Bridges & Switches 

> What they are?
> - Simple [Network Bridge](https://en.wikipedia.org/wiki/Network_bridge) : Lv2-device connecting 2 network segments 
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
>   - ARP spoofing is used **as opening for other attacks** 
>   - DOS / MITM / Session hijacking  
> - ARP has **no authentication mechanism of source host**
>   - this is a Vulnerability of the protocol
>   - attacker can send (spoofed/forged) ARP messages and redirect traffic

[Gratuitous ARP response](https://www.practicalnetworking.net/series/arp/gratuitous-arp/) : *broadcast packet* used by hosts to “announce” their IP address to the local network *without any ARP request*

Attacker can flood network with Gratuitous ARP responses and hosts will link IP of default GW with MAC address of Attacker

# IPv6 Neighbor Discovery --- ARP poisoning for IPv4
IPv6 Neighbor Discovery threats

- how addr resolution works in IPv6?

- known threats  RFC 3756

● IPv6 Rogue RA (or RA spoofing)
● Rogue DHCP



FORSE POSSO METTERE TUTTO DENTRO I LAB...

 
 ++ LAB 3 Activity