# Security Information and Event Management (SIEM)
> 2 main approaches to Cybersecurity combining:
> - information management (SIM)
>   - **Collects log data**(Log != Event) for analysis, alerting responsible individuals of security threats and events
> - event management (SEM)
>   - Conducts **real-time system monitoring**, notifies network admins of important issues, and establishes event correlations
> Not a single tool or application, but a set of different building blocks that all constitute part of a system
> 
> GOAL $\rightarrowtail$ help organizations detect and mitigate threats 

There is no standard SIEM protocol or established methodology

They should be providing the following collection of services:
|Log management|IT regulatory compliance|Event correlation|Active response|Endpoint security|
|--|--|--|--|--|
|automatically collect and process information from distributed sources |produce reports of violations, threats and monitoring |correlate different events|Automatic response to threats|adjust Endpoint security remotely |
|store it in one centralized location|help for compliance and security incident management (digital forensics)||||

- Dashboards and maps → pull of information
- Alerts → push of information
## Log Management

Nodes in an IT system (the more important or *critical nodes*) send relevant system and application events (logs) to a centralized database that is managed by the SIEM application
- This SIEM database application first parses and normalizes the data sent by the numerous and very different types of nodes on an IT system
- the SIEM typically provides ***log storage, organization, retrieval, and archival services*** to satisfy the log management requirements that businesses may have
- The **more nodes that feed** into your SIEM system, the more **complete and accurate your vision is** of the IT system as a whole
  - SIEM system lends itself to the additional use of **near real-time analysis and data mining** on the health and security status of all the IT systems feeding their data into the SIEM system

### logs are fundamental !!
> Logs are the events that your network produces: Without them, *it is impossible to achieve any security management*
> - Event data(logs): exact list of all events that occurred on your server, network, or website
> - State data: view of the overall state of the system (Configurations, Current applications, Active users, Processes, Registry settings, Vulnerabilities etc..)
- Which devices will you collect events from?
  - Critical servers, devices providing access to critical servers, IDS
  - Optional: network endpoints (maybe only aggregated via other services)
- Which events will you collect?
  - Debug info, log-in records, configuration changes, alerts...
- How long will you keep the logs?
  - Balance between needs and desires
- Where will you store the logs?
  - Local storage, cloud, hybrid solutions

## IT Regulatory compliance

![image](/images/siem.PNG)

Build filters or rules and timers *to audit* (monitor against a standard) *and validate [compliance](https://www.bancaubae.it/compliance/#:~:text=La%20Funzione%20di%20Compliance%20%C3%A8,causa%20del%20mancato%20rispetto%20di),* or to identify violations of [compliance requirements](https://en.wikipedia.org/wiki/Compliance_requirements#:~:text=Compliance%20requirements%20are%20only%20guidelines,large%20number%20of%20federal%20programs.) imposed upon the organization
- produce *reports* often needed by businesses to provide evidence of self-auditing and to validate their level of compliance
- examples:
  - monitoring the frequency of password changes
  - identifying operating system (OS) or application patches that fail to install
  - auditing frequency of antivirus,antispyware, and IDS updates for compliance purposes...

> All forms of compliance ***ask the fundamental question*** related to diligence:
> 
> *Have you taken the steps **to perform your responsibilities to securely manage** the information in your control—which a reasonable person would expect of someone in your position?*
>
> *if you had to defend your actions in this regard in front of a jury of your peers, would you be comfortable stating that you had used **available best practices** and **sufficient effort** to perform your duties?*

### Evidence of best practices

Implementing technologies to protect and detect intrusions *is not enough* $\rightarrowtail$ This should be provable
- The log server has to be reliable *(TCP,encrypted storage)*
- important to sign the logs *(Authentication and integrity)*

SIEM can also include compliance checklists (SPLUNK)

### Threat intelligence 

> the analysis of data using tools and techniques **to generate meaningful information about existing or emerging threats** targeting the organization that helps mitigate risks 

- it feeds and reports help security officers in making decisions concerning organizational security
- helps organizations make faster, more informed security decisions and change their behavior from reactive, to proactive and to combat the attacks

### Digital forensics

> a branch of forensic science focused on **the recovery and investigation of material found in digital devices** and cybercrimes 

- is concerned with the identification, preservation, examination and analysis of digital evidence, using scientifically accepted and validated processes, **to be used in and outside of a court of law**

## Event/log correlation
Monitoring the incoming logs for
- Logical sequences
- Patterns
- Relationships
- Values
> The ultimate goal is to analyze and **identify events invisible to individual systems**

investigate and consider **(correlate) other events** that are not necessarily homogeneous
- provide a more complete picture of the health status of the system to rule out specific theories on the cause of given events
- Correlation engines usually are the most distinguishing feature of SIEM
- Define a common syntax to represent events in the SIEM and apply it to the logs
- Make use of correlation rules *that can trigger alerts or actions*
## Active Response

Activate procedures after the identification of given (security) events: Automatic/Manual response
- The SIEM triggered, automated, and active response to the perceived threat would probably occur much faster

## Endpoint Security
monitor endpoint security to centrally validate the security “health” of a system
- *manage endpoint security*
  - actually making adjustments and improvements to the node’s security on the remote system
  - push down and install the updates, or in Active Response mode, adjust the ACL on a misconfigured personal firewall
  - Patching the operating system and major applications
  - Management of removable media, such as USB drives and CD and DVD burners
  - etc...

- [Host Intrusion Detection Systems](https://en.wikipedia.org/wiki/Host-based_intrusion_detection_system) (HIDS) **(Monitor, detect and alert)**
- Host Intrusion Protection Systems (HIPS) : aims to stop malware by monitoring the behavior of code **(runtime detection + try to do something)**
    - ***[ref1](https://security.stackexchange.com/questions/109442/what-is-the-difference-between-a-hids-hips-and-an-anti-virus)*** | ***[ref2](https://thecyphere.com/blog/host-based-ids/)***
- [Network Access Control](https://en.wikipedia.org/wiki/Network_Access_Control) (NAC)
- Network Intrusion Detection Systems (NIDS)
- Network Intrusion Protection Systems (NIPS)
  - ***[wiki](https://en.wikipedia.org/wiki/Intrusion_detection_system)***
  - [ref](/[[8]Network%20Monitoring/TODO![2]IDS.md])