# Iptables Fundamentals
- [Netfilter](https://it.wikipedia.org/wiki/Netfilter) : linux kernel framework that provides hook handling for intercepting & manipulating network packets
- [Hooks](https://en.wikipedia.org/wiki/Hooking) : entities (like modules) that allow packets `manipulation` during their traversing
  -  when intercepted by there hooks the IP packet is verified against a given set of `matching rules` and processed by an `action` configured by the user  
- [Iptables](https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html) : Userspace level configurator
  - *order of matching rules is important*
  - packets fates depend on the *first matching rule*
  - If no match the *default policy will be applied*
 
> ***TABLES** (operation over a packet) as set of **CHAINS** (how packets are elaborated)(queues) as set of **RULES**(match+action);*

every chain has its default policy

## built-in tables 

each table defines a different kind of operation that can be perform over the packets 

- **filter** => filtering of packets : allow or block packets (accept/drop), every packet pass through this table
  - (INPUT / OUTPUT / FORWARD)
- **nat** => address-port translation (SNAT/DNAT/MASQUERADE) : the first packet of a connection pass through this table then its result define behavior of next packets belonging to the same connection
  - (PRE_ROUTING / POST_ROUTING / OUTPUT)
- **mangle** => packet header modification (QoS), every packet pass through this table and contain all predefined chains
  - (PRE_ROUTING / POST_ROUTING / INPUT / OUTPUT / FORWARD )
- **raw** => avoid connection tracking
  - (PRE_ROUTING / OUTPUT)

## built-in chains

> ![picture 1](../images/757f07dd756b276a90b3bd92a17b96a140eb2ed35cdd70c5e495ec8306c1f753.png)  

Every packet pass through a set of hook-chains of multiple tables, each rule inside tables check a match. If match, the other rules will be ignored


> ![picture 2](../images/076443cd74e3f0e366e1f477ceb76d6fca88ca3e73a10bed722cc2e5d2544463.png)  

## Iptables Flow

- local generated packets : 
  - Local Process -> OUTPUT -> POST_ROUTING -> NET
- Forwarded Packets :
  -  NET -> PRE_ROUTING -> FORWARD -> POST_ROUTING -> NET 
- Locally Addressed packets :
  -  NET -> PRE_ROUTING -> INPUT -> Local Process

## build-in rules

> match rule + target / Action




# ex 1,2,3


i just need to follow instructions:

Do 3 step rules construction 

LAB activity lex 10

take it from NI. devo dire che NI è l'esame in cui ho fatto meglio iptables....

