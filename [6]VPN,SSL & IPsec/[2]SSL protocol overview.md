# SSL protocol Architecture 
> protocol adds security between transport and Application layer with extra element to App-layer
- [SSL Protocol Stack](https://www.geeksforgeeks.org/secure-socket-layer-ssl/?ref=lbp):
  - ![image](/images/ssl%20stack.png)
  - App-layer elements: control operation of the record protocol 
    - SSL handshake: Used to authenticate server (and optionally client) and to agree on encryption keys and algorithms
    - SSL Change cipher spec: Selects agreed keys and encryption algorithm until further notice
    - SSL Alert: Transfers information about failures
  - transport-layer element
    - SSL Record Protocol: Protocol offering basic encryption and integrity services to applications
    - provides Confidentiality + Message Integrity
- SSL's PDU steps:
  - ![image](/images/SSL_pk.PNG)
  1. fragmentation into blocks $\leq 2^{14}$ bytes
  2. (optional) Lossless compression
  3. add Keyed MAC using shared secret MAC key
  4. Encryption using session key
  5. add header specifying App-protocol in use

### SSL Handshake
> establish a **session in 4 phases**: establish protocol, ciphers and session-Key used + authentication of Server and host(optional)
> ![image](/images/hand.PNG)
1. **Hello** Establishment of security capabilities: 
   1. Client sends list of possibilities, in order of preference
   2. Server selects one, and informs Client of its choice
   3. Parties also exchange random noise for use in key generation 
2. **Server authentication** and key exchange:
   1. Server executes selected key exchange protocol (if needed)
   2. Server sends authentication info. (e.g. X.509 cert.) to client
3. **Client authentication** and key exchange: 
   1. Client executes selected key exchange protocol (mandatory)
   2. Client sends authentication info. to Server (optional)
4. **Finish**:
   1. Shared secret key is derived from pre-secrets exch. in 2, 3
   2. Change Cipher Spec. Protocol is activated
   3. Summaries of progress of Handshake Protocol are exchanged and checked by both parties
> ### SSL Security Capabilities
> sting exchanged in the first phase of SSL-handshake specifying:
> - Version of SSL/TLS
> - Key exchange algorithm
> - Grade of encryption (previous to TLSv1.1)
> - Encryption algorithm
> - Mode of block encryption (if block cipher used)
> - Cryptography checksum algorithm
> 
> example: TLS_RSA_WITH_AES_128_CBC_SHA
> 
> (Latest version of) TLS + RSA key exchange WITH (merely filler...);
> 
> 128-bit AES encryption && CBC Cipher Block Chaining && HMAC-SHA digest

> ### SSL Key exchange and authentication
> Possible ways of agreeing on secrets in TLS are: RSA, DHE RSA/DSS, DH RSA/DSS...
> 
> “Key exchange” only ***establishes a pre-secret***!
> 
> From this, a master secret is **derived by a pseudo-random function**(PRF). 
> 
> Shared secret encryption key is derived by expansion of master secret with another PRF

# SSL/TLS heartbeat (Buffer Overflow Attack)
It is an extension (RFC 6520) that allows **to keep an established session alive**
   - When one endpoint sends a HeartbeatRequest message to the other endpoints, the former also starts what is known as *the retransmit timer*
     - During the time interval: the sending endpoint will not send another HeartbeatRequest message
   - An SSL/TLS session is considered to have **terminated in the absence of a HeartbeatResponse** packet within a time interval

As a protection against a replay attack: HeartbeatRequest packets include a payload that must be returned without change by the receiver in its HeartbeatResponse packet

### Heartbleed bug
> ![image](/images/Heartbleed_explanation.png.png)

The receiver of request did not check that **the size of the payload in the packet** actually equaled **the value given** by the sender to the payload length field in the request packet
   - The attacker sends little data but **sets the size to max**
   - The receiver **allocates that amount** of memory for the response and ***copied max bytes from the mem location where the request packet was received***
   - Then, the actual ***payload returned could potentially include objects in the memory*** that had nothing to do with the received payload
     - Objects could be private keys, passwords, and such...