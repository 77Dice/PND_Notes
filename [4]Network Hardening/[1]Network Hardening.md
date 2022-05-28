# Network Hardening
Computer networks are composed by different devices, if even one of them **is breached**, the entire infrastructure **can be compromised**

>**methodology** *to protect network devices*

- to reduce the risk of violations
- to limit the impact of anomalous events : whether
they are voluntary (attacks) or involuntary (human
errors or failures)

> ## Scopes if action 
> - **Management plane** --> Network Device *Management*
>   - consists of admin's *protocols and tools* to configure, monitor or access a network device (SSH, SNMP, NTP)
> 
>*Breaches when* --> overly simple passwords + insecure 
protocols 
> 
> *resulting in* --> unauthorized access + loss of access to the device
> 
> - **Control plane** --> *support* Network device's Operations 
>   - consists of *routing protocols* and everyday mechanisms
> to perform tasks
> 
> *violations when* --> unauthorized data exchange
> 
> *resulting in* --> loss of performance (DoS)
> 
> - **Data plane** --> *operations* of network devices 
>   - consists of *the traffic* forwarded by devices and the paths that appliances choose for individual packets 
> 
> *violations when* --> external events + malicious interventions(spoofing, redirect, hijacking, etc.) + failures
> *resulting in* --> alteration of packets and block of networks services 

- In all the three areas of action of the network devices
it is possible to have violations
- The three areas are closely linked, as anomalies in
one can be reflected in the others
- It is important, therefore, to adopt **best practices** protecting devices in all three areas

## Management plane protection

### Appliance access protection

Access network devices by cable reduce risk of claims of being the administrator through remote connections 

### Password policy

use passwords difficult to guess  + change it frequently  + not overcomplexes 

#### brute force protections 
minum length x ensure impracticability of brute force attacks +
store passw in encrypt way 

### AAA principle ...
