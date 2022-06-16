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

![image](/images/alarm.PNG)

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

# IDS approaches
two different approaches: one based on *white lists(behavior-based)* where if an activity is known then it will not be blocked and the other based on *black lists(signature-based)* where if an activity is similar to a known threat then it will be blocked and reported

*Problem? $\rightarrowtail$ you can only detect what is inside the databases*

Decision on which approach depends on ***what do you know better/be able to detect***: good behavior or known threats  

- How to recognize normal and abnormal behavior patterns?
  - intruders/attacks may have **a characteristic appearance** which makes it possible to identify them(signature based)
- How quickly can recognition take place?
- How do we deal with abnormally behaving systems?

## Behavior-based (**anomaly detection**) 
> from **historical data we compare current** patterns in order to generate and report an alert
> - Define behavioral characteristics of normal behavior
>   - collection of safe and accepted activities inside DB
> - raise alarm if current activities seems out of scope or suspicious
>   - Compare actual behavior with these; If there are significant differences then **raise an alarm**
> - susceptible to false positives
>   - Difficult to define all possible normal behavior
>   - *New activities often give **“false positives”*** (i.e. normal behavior is classified as intrusion)
>   - **Adaptive profiles and Self-learning mechanisms** can avoid raising false alarms

![image](/images/IDS3.PNG)

Behavior is typically described in terms of **a set of features**

The feature set should describe **all relevant aspects of the behavior to be recognized**
  - Wireless networks: Signal power, Sequence number ”jumps”, Round-trip time (RTT)... 
  - Grid/cloud systems: GridFTP connections, GridFTP mode of operation, Number of GridFTP clients (evidence of ”Flash crowds”), Traffic entropy, Type of LDAP operations...
  - How can you prove that they are effective?
    - Open problem 

Anomaly-based detection mechanisms (both protocol and statistical) are useful for IDS, but inappropriate for IPS
- *Anomaly filters can not be used for blocking, only for alerting*

### Behavioral w.r.t. anomalies
1. Take sequence of observed behavioral elements (system calls, network packets or others)
2. Derive the “normal” behavior, generated using statistics or with a set of rules (like parameters or procedures) or with a Machine Learning/Data mining approach
   1. Distance measures (statistics and thresholds): [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance), [Mahalanobis distance](https://en.wikipedia.org/wiki/Mahalanobis_distance), [Kolmogorov complexity](https://en.wikipedia.org/wiki/Kolmogorov_complexity) ...
   2. Probability measures “how likely is this sequence?”
   3. Rule sets "does the sequence follow a set of pre-defined rules?"

## [Signature-Based](https://it.wikipedia.org/wiki/Signature_based_intrusion_detection_system) (**misuse detection**) 
> from **attack signature (characteristics of attacks)**; similar to Behavior but based on elements from known Attacks (attack signature)
> - Define characteristics of various types of abnormal activity
>   - collection of known threats (as antivirus DB)
> - raise alarm if some behavior match with it 
>   - Compare actual behavior with these; If any of them match **raise alarm!**
> - Susceptible to false negatives
>   - Difficult to produce a complete catalog of abnormal activities
>   - *If any are missing(not updated DB...), there will be **“false negatives”*** (i.e. undetected intrusions/Attacks)
> - Pattern matching mechanism
>   - to screen the PAYLOADS of the packets looking for specific patterns: signatures
> - Rapid recognition 
>   - searching for matches from a collection of many thousands of signatures
>   - suppliers of IDSs maintain *huge databases of signatures*(code or data fragments) which characterize various classes of intruder

![image](/images/IDS4.PNG)

IDEA: Captures the packets in a LAN and applies some fairly complex logic to decide whether an intrusion has taken place
- A packet sniffer “on steroids”
- uses DPI: deep packet inspection
  - Decode application and protocol headers to look *at high-layer activity*
- Cons:
  - can not inspect encrypted traffic (VPNs, SSL)
  - not all attacks arrive from the network
  - record and process huge amount of traffic


## [Misuse detection](https://en.wikipedia.org/wiki/Misuse_detection)

IDEA: Set of rules defining an **abnormal behavioral signature** associated with an attack of a certain type
- Use **invariant characteristics** of known attacks
  - Bodies of known viruses and worms,
  - port numbers of applications with known buffer overflows
  - RET addresses of stack overflow exploits ...

Challenge $\rightarrowtail$ fast, automatic extraction of signatures of new attacks

### [Honeypots](https://en.wikipedia.org/wiki/Honeypot_(computing))

> ***def.*** A security resource whose value lies in it being attacked, probed or compromised.
> - useful for signature extraction
> - Try to attract malicious activity, be an early target
> - The idea is to attract the attackers
> A honeypot is usually a single computer or a network of computers protected by a firewall to regulate traffic

[How evade IDS rules?](http://books.gigatux.nl/mirror/snortids/0596006616/snortids-CHP-4-SECT-4.html)

" how pass NIDS with USER_ROOT" and elude IDS:

#### Insertion Attack

Attacker will insert inside the payload a set of bits with bogus checksum, Verification will fail and IDS will drop that specific sequence.
Then, Passed the IDS the original packet will have USERROOT!!

GOAL: pass intrusion detection check by cover it by bogus checksum 

#### TTL Attack

split USER_ROOT in more packets(different payloads) with high TTL, after IDS it will be reassembled in USER_ROOT

# Signature vs. Behavior
Signature-based detection
- Clearly indicates the detected attack method

Signature “can not” detect:
- DoS/DDoS, Zero-day exploits, Protocol/application anomaly

Behavioral-based alerts indicate:
- The attack type
- The behavioral rule that was violated, such as port scan
- The statistical profile that was violated

Behavioral protection **can not identify the specific attack or exploit** that was blocked
- Require security administrator to investigate clues given by the behavioral rule to determine which attack was actually attempted
- Acceptable for new and unknown attacks
- established threats and known exploits *should be easily identifiable*

Behavioral-only system becomes **unmanageable for a large number of hosts**

> *** The Best solution is to combine*** both signatures and behavioral rules
> - No false positives: Do not ever block legitimate traffic under any circumstances
> - No false negatives: Do not miss attacks, even when the attacker intentionally tries to evade detection

# IDS vs. IPS

|IDS|IPS|
|--|--|
|out of band|in band|
|No interference with traffic|To match the line speed: [ASIC](https://it.wikipedia.org/wiki/Application_specific_integrated_circuit) or PFGA|
|a false positive is an alert that did not result in an intrusion|a false positive will also block legitimate traffic|
|-|IPS **cannot have false positives**|

# IDS Components 

![image](/images/IDSCOmp.PNG)
- Network sensors: detect and send data to the system
- Central monitoring system: a server that processes and analyzes data sent from sensors
- Database and storage component: repository for event information