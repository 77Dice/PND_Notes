#  Intrusion Detection/Prevention Systems 

> [(IDS)](https://en.wikipedia.org/wiki/Intrusion_detection_system) aims at **detecting/reporting the presence of intruders before** serious damage is done
> - Record/notify information related to important events to security admin
> - producing reports & provide details 
> 
> Second generation IDS are IPS: produce **responses to suspicious activity and block/change the network activity** 
> - by modifying firewall rules or blocking switches ports
> - Drop connections, block accesses
> - change configurations of other devices, change of the content of packets (normalization of the requests) ...
> 
> "Network" IDPS are based on *Deep packet inspection*(payload)
> - IDS $\rightarrowtail$ ***out of band*** (no hop into the network / as span port / passive)
> - IPS $\rightarrowtail$ ***placed in-line***  (as hop in the network / active)

### Alarms 
> GOAL: *always detect True positive & True Negative* 
IDS needs to detect a substantial percentage of intrusions with few false alarms;

Alarms can be raised (positive) or not (negative)
- If too few intrusions detected → no security
- If too many false alarms → ignore

### Activities monitored by IDS/IPS
Investigate any sensitive activity
- attempted and successful breach:
  - Reconnaissance
  - *Patterns of specific commands* in application sessions
    - successful remote login session contains $\rightarrow$ authentication commands + login and location frequency
  - Content types with *different fields* of application protocols
    - password for an application must be 7-bit ASCII of 8 to 64 allowed characters to avoid buffer overflow and SQL injection
  - Network *packet patterns* between protected servers and the outside world
    - Client application, protocol and port, volume and duration, Rate and burst length distributions for traffic
  - Privilege escalation
- Attacks by legitimate users/insiders
  - Illegitimate use of root privileges
  - Unauthorized access to resources and data
  - Command and program execution (Mouse, keyboard, CPU, disks, I/O patterns...)
- Malware:
  - Rootkits/Trojans/Spyware
  - Viruses, zombie and worms
  - Scripts
  - Hard to handle mutations
    - Polymorphic and metamorphic viruses: **each copy has a different body**
- Denial of service attacks
  - Rate and burst length distributions for all types of traffic

### IDS/IPS structure & types
general block model for different kinds of IDS (host/network/wireless IDSs)
- detection engine is usually **knowledge/comparison based** (database/known thread based)

![image](/images/IDS1.PNG)
function blocks
![image](/images/IDS2.PNG)

|types|deployed...|Advantage|GOAL|
|--|--|--|--|
|Host-based (HIDS)|on critical hosts offering public services|better visibility into behavior of individual applications running on the host|Monitors events in a single host to detect suspicious activity|
|Network-based (NIDS)|behind a router or firewall that is the entrance of a critical asset|single NIDS/IPS can protect many hosts and detect global patterns|Analyses network, transport and application protocol activity|
|Wireless (WIDS)|near an organization’s wireless network|-|Analyses wireless networking protocol activity (not T- or A-layers)|
|File integrity monitors|-|-|Monitor changes to key system configuration files|
|Flow-based IDS (NetFlow)|-|Establishes patterns/behaviors of traffic |Tracks network connections|
|--|-|situational view on large network(s)|Alert when unusual services/patterns/protocols/behaviors seen|

- HIDS looks for unusual events or patterns that may indicate problems
  - No Promiscuous mode (single running host activity)
  - Unauthorized/Unexpected access and activity
    - Changes in configurations & Software
- NIDS as sniffer is usually connected to switches with ports mirrored ([SPAN mode, Switch Port ANalizer](/Labs/%5B1%5DNetworking%20101%2Bscript.md##%20Network%20Traffic%20Monitoring))
  - Promiscuous Mode active
  - Distributed detection system : it has a series of sensors placed in different networks
  - search for network patterns (DB based)
- Hybrid detection capabilities:
  - Augment or replace signature-based detection
  - Usually anomaly/behavior-based (pseudo-artificial intelligence)
  - Often require “training” periods to establish a baseline

## IDS approaches

> Behavior-based **anomaly detection**: from **historical data we compare current** patterns in order to generate and report an alert

![image](/images/IDS3.PNG)

> [Signature-Based](https://it.wikipedia.org/wiki/Signature_based_intrusion_detection_system) **misuse detection**: from **attack signature DB(characteristics of attacks)**; similar to Behavior but based on elements used from Attacks

![image](/images/IDS4.PNG)

*Problem? $\rightarrowtail$ you can only detect what is inside the databases*

### How to recognize an intrusion?



