# Network Address Translation - NAT

- NAT is **NOT a SECURITY FEATURE**
- IPv6 reachability is **NOT a DOWNSIDE** because a good firewall policy can make the internal network secure
- A private network uses just **one Public IP address** provided by ISP to connect to the Internet
- NAT Goals :
  - Does not provide security
  - Does not expose Private Hosts outside
    - Devices inside private network are **not explicitly addressable** by external network, or visible by outside world 
  - Allow change of Host's Addresses in private Network without notifying outside world
  - Allow change of ISP without changing the address of devices in private network
> these Goals are Overcome by IPv6 : now they are **All Routable Addresses**

### Source NAT (SNAT)

> Translate **outgoing** requests : The session is Masqueraded as coming from the NAT device 
- Translation reference is kept inside the **NAT Table**
- The *NAT table* is where associations between **requests :: internal IP addresses** are kept
- every packet related to the session will be translated based on that 
- enable the client-server session to continue on **another port**; forwarding any response by the server to the client **(RELATED packet)**

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