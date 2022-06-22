Lex 18 IPSec LAB!@!!

# Fundamentals of IPsec

- Data origin authentication
- Connectionless Data Integrity
- Confidentiality
- Security Policies

## IPsec overview
GOAL : agree in how make communication secure 

Manual OR automated (ISAKMP,IKEv2...)

## IPsec Standard documents...

[IPsec_RFC_reference](https://datatracker.ietf.org/wg/ipsec/documents/)

## IPsec Architecture(RFC 4301)  + view

just index ...

***main picture!!***
> Sec policy database (SPD) : store policy of admin

> Security Association database (SAD): were store SA defined with hosts 

![image](/images/ipsec_over.PNG)


### Security policies
which SP should be provided to IP packets and their details 
**example and CODE**
from[any] dest[any] define ports; //require--> if don't have SA(esp/transport) don't send the packets 

- type of action related(Discard, Secure, Bypass)

###  SA
added some info before 
### (SAD)
some info in plus 
**example and CODE**

E: is key in use
SPI: is different SA (800/801)

## Processing traffic (in/out) 
phases of 

***
# Implementation
it's already in the kernel 

we will se how interact with it

ipsec-tools (just educational purpose) (setkey+racoon)

use [STRONG_SWAN](https://www.strongswan.org/) for everyday use
or Libreswan


how setup SP + SA...

...