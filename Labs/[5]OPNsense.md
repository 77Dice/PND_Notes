# OPNsense

How manage every plain protection?

## Management plane protection
Use strong passwords
- Change the default password

Use encrypted communication
- Make sure to log in only using HTTPS
 
Configure NTP service on internal interfaces

Send logs to a syslog server (graylog)
- Configure opnsense to send logs to a centralized server

## Control plane protection
Protect against too many ICMP messages
- Limit incoming ICMP traffic (shaper)

Block potentially malicious ICMP messages
- Filter redirect and unreachable ICMP messages from external sources (floating rules)
- ICMP unreachable messages explicit block rule inside floating table

## Data plane protection
Block packets with spoofed IP address
- Filter packets with IP addresses not coming from local networks
- filter packets inside interfaces tables and not inside floating table 

Allow only packets that match the traffic expected on the network
- Allow access to the DMZ only to packets that require the services provided