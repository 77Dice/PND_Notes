# Network Address Translation - NAT

> [wiki](https://it.wikipedia.org/wiki/Network_address_translation)

    Basic NAT : translate IP addresses of hosts within a private domain as they communicate with external domain + change IP headers, fields and checksum

- NAT is **NOT a SECURITY FEATURE**
- IPv6 reach ability is **NOT a DOWNSIDE** because a good firewall policy can make the internal network secure
- A private network uses just **one Public IP address** provided by ISP to connect to the Internet
- NAT Goals :
  - Does not provide security
  - Does not expose Private Hosts outside
    - Devices inside private network are **not explicitly addressable** by external network, or visible by outside world 
  - Allow change of Host's Addresses in private Network without notifying outside world
  - Allow change of ISP without changing the address of devices in private network
> these Goals are Overcome by IPv6 : now they are **All Routable Addresses**

### Source/Destination NAT (SNAT)

> Translate **out/ingoing** requests : The session is *Masqueraded* as coming from the NATting device 
- Translation reference is kept inside the **NAT Table**
  - The *NAT table* is where associations between **requests :: internal IP addresses** are kept
- every packet **RELATED** to the session will be translated based on that 
- enable the client-server session to continue on **another port**; forwarding any response by the server to the client **(RELATED packet)**

### Network Address Port (NAPT)

When we map multiple private hosts *to one single* external/public IP 
We bind connections to TCP/UDP port numbers in the NATting device.

- Port forwarding 


### destination NAT (DNAT)


# LAB4 related
SLIDE 11 : 5 aprile


- exists NOT ROUTABLE addresses and only public ADDR are routable
- different types of NAT
  - source / port / destination / 
- tap table inside iptables 

+ lab4

> 


[link1](https://www.computernetworkingnotes.com/networking-tutorials/ipv6-neighbor-discovery-protocol-explained.html)

[link2](https://www.computernetworkingnotes.com/)