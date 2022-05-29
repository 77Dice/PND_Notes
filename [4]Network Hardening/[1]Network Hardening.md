# Network Hardening
Computer networks are composed by different devices, if even one of them **is breached**, the entire infrastructure **can be compromised**

>**methodology** *to protect network devices* : 
> 
> **The purpose** of network devices is to move packets through the network according to the security policies established by governance
> 
> Without proper protections, attacks can be made to alter packet forwarding rules, potentially causing security policy violations

- to reduce the risk of violations
- to limit the impact of anomalous events : whether
they are voluntary (attacks) or involuntary (human
errors or failures)

> ## Scopes if action 
> - **Management plane** --> Network Device *Management*
>   - consists of admin's *protocols and tools* to configure, monitor or access a network device (SSH, SNMP, NTP)
> 
>*Breaches when* --> overly simple passwords + insecure protocols 
> 
> *resulting in* --> unauthorized access + loss of access to the device
> 
> - **Control plane** --> *support* Network device's Operations 
>   - consists of *routing protocols* and everyday mechanisms to perform *network tasks*
> 
> *violations when* --> unauthorized data exchange
> 
> *resulting in* --> loss of performance (DoS)
> 
> - **Data plane** --> *operations* of network devices 
>   - consists of *the traffic* forwarded by devices and the paths that appliances choose for individual packets 
> 
> *violations when* --> external events + malicious interventions(spoofing, redirect, hijacking, etc.) + failures
> 
> *resulting in* --> alteration of packets and block of networks services 

- In all the three areas of action of the network devices
it is possible to have violations
- The three areas are closely linked, as anomalies in
one can be reflected in the others
- It is important, therefore, to adopt **best practices** protecting devices in all three areas

# Management plane protection

- [Appliance](https://it.wikipedia.org/wiki/Appliance) access protection: 
  - Access network devices **by cable** reduce risk of claims of being the administrator through remote connections
  - usually access is **physically restricted**
- Password policy:
  - use passwords difficult to guess
  - at least **8 characters long**
  - alphanumeric + upper & lower case + special symbols + punctuation marks
  - **changed frequently**
  - **not over complex** because otherwise they require to be transcript ed
- Brute force Protection
  - minimum length ensures **impracticability** of brute force attacks(8 characters = $3.6*10^{15}$)
  - score password in an **encrypted way**
  - [reference](https://www.coresecurity.com/blog/the-exponential-nature-of-password-cracking-costs)

## Use The AAA Principle
> Idea of **reducing unauthorized access to resources** by identifying users and allowing them access only to those components for which they are authorized, keeping a record of their actions

- **Authentication**
  - username/password or tokens
- **Authorization**
  - User/permission association
  - **[RBCA(Role base Access Control)](https://en.wikipedia.org/wiki/Role-based_access_control)**: user has different roles and linked to them different permissions
- **Accounting**
  - store details of every action taken by users in a **permanent and unalterable log**

## Use Centralized Solutions
> configure solutions that concentrate AAA functions in
a single point in network devices, for example, an **ACS, Access Control Server**

The network devices (switches or routers) connect to the server and interact with it *every time they need to verify the identity of a user trying to access it*, the user's permissions, and record the actions it performs

Alternative is the local solution: each device has its own set of users, passwords and permissions (if Auth Server is unavailable)

## Use a Reliable NTP Server

> For reliable Accounting and Auditing, all devices must know
the current time correctly : For this purpose, **the Network Time Protocol (NTP) is used**
> - NTP version 3 is preferred: it makes use of *authentication and integrity verification* mechanisms
> - This ensures that all logs from all devices **can be compared**
temporally.

- Usually, one of the devices on the network is designated as the
**reference NTP server**, and all the other devices interact with it to synchronize with its time
- This device, in turn, can refer to another **trusted NTP server**, perhaps one that can be *reached on the Internet*, to receive the current time accurately

## Remotely Access using Encryption

> Remotely accessing network devices must be done securely, i.e., using encryption protocols

- For devices that require command-line configuration (CLI)
  - **avoid telnet**, which is an unencrypted protocol
    - only use telnet on an **isolated channel** (not intercepted) or within an **encrypted tunnel** (such as a VPN)
  - **SSH v2** should **always be preferred**, as it offers the same functionality as telnet but encrypts every packet exchanged between the device and the administrator

- For devices that provide configuration through a graphical interface (GUI)
  - **avoid HTTP protocol** (clear)
  - **prefer** the use of **HTTPS** (encrypted)

# Syslog 

> [Configure Syslog](https://www.computernetworkingnotes.com/linux-tutorials/how-to-configure-syslog-server-in-linux.html)
syslog is a standard mechanism for generating log messages (*CRITICAL ELEM*)

- messages are stored in plain text: a time stamp (synchronized thanks to NTP) with a text message

-  for individual log messages, ordered in such a way that levels with  than those with high values

|eight levels of criticality (severity)|*low values have higher criticality*|
|--|--|
|0 Emergencies, 1 Alert, 2 Critical|5 Notifications, 6 Informational| 
|3 Errors, 4 Warnings|7 Debugging|

It is therefore essential:
- to choose the appropriate level of criticality
  - *limit the use of Debugging* only to the time required to solve a sudden anomaly
- that the Syslog server has an adequate **log storage capacity**, both in terms of space and computing capacity

# Control Plane protection
Prevents devices from using non-genuine information 
>1. avoid **unauthorized changes** to the way traffic moves through the network 
>    - routing protocols *with authentication* --> to forwarding packets according to the correct routes

it is best to use **the authenticated version of the routing protocols** wherever possible
- reduce the risk of using information for *non-genuine traffic routing*
- ensures that unauthorized routers *cannot distribute false information*
- ensure that packets with routing information from other routers are authentic

> 2. avoid **overloading devices** (denial of service attacks)
>     - Specifically **targets CPU limits** of the Network devices 
>     - flooding routers with packets for processing can impact their performance and cause a DoS attack

it is ***good practice*** to use the ICMP packet filtering mechanism ***to block*** the following ICMP packets:
- *ICMP redirects* : which suggest an alternate route if the destination can be reached through another router in the same network
  - They can be used to indicate a different gateway and, thus, **exposed to a man-in-the-middle**
- *ICMP unreachable* : which informs the sender of a packet that the final destination is unavailable (e.g., not responding to ARPs or no route to that destination)
  - The unreachable ICMPs, besides overloading the CPU of the routers, can be **used to know the internal topology of a network**

> Control Plane Policing & Ctrl Plane Protection are series of measures that can **limit the packets** addressed directly to the devices and **that require the use of their CPUs**

# Data Plane protection
because network devices operate with virtually **no administrator intervention once configured**, it is challenging observing security policy violations *without proper monitoring*

Therefore, data plane protection **must be as thorough as possible**:

$\rightarrow$ it is necessary to intervene in several protocol stack layers

## Level 2 Protection(switch Configuration)
> you have to protect devices from possible MAC-IP association changes

- Disable gratuitous ARP packets 
  - To avoid [ARP spoofing attacks](/Labs/[4]LInk-Local%20Attacks%20&%20brctl.md#%20ARP%20Spoofing/Poisoning) (MAC address theft), typical of man-in-the-middle attacks
- Enable [dynamic ARP inspection](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst4500/12-2/25ew/configuration/guide/conf/dynarp.html) (DAI) mechanism
  - To protect against ARP spoofing and ARP poisoning, typical of man-in-the-middle attacks
- Disable ARP Proxy IP if not needed
  - IP proxy ARP allows ARP packets to traverse routers when a logical network is physically divided by routers and not just switches. This can be exploited for man-in-the-middle attacks
- Enable port security mechanism
  - Allows only a limited number of MAC addresses to be exchanged, preventing attacks such as CAM table overflow, DHCP depletion, or misuse of a switch port
- Enable DHCP snooping mechanism
  - This allows DHCP response packets to be forwarded only from authorized ports connected to a
trusted DHCP server
- Enabling the IP source guard mechanism
  - To allow blocking all traffic with an abnormal IP-MAC address association, typical of IP spoofing

## Level 3,4 Protection (ACLs and traffic filtering)

> The main tools to protect networks are **Access Control Lists (ACLs)** used for packet filtering functions

