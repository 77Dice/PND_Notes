# Proxies
> - [idea](https://en.wikipedia.org/wiki/Proxy_server): one single host handling requests from several users
> - you need only one rule in Firewall for a proxy
> - only the proxy can access the internet (HTTP, FTP etc..)

- Authentication, Authorization, Auditing
- whitelisting, blacklisting (**Content-filtering Proxy**): proxy controls over the content that may be relayed
- Caching $\rightarrow$ store the retrieved document into a local file for further use so it won’t be necessary to connect to the remote server the next time that document is requested
  - How long is it possible to keep a document in the cache and still be sure that it is up-to-date?
  - How to decide which documents are worth caching and for how long?
  - Solutions:
    - HEAD HTTP request (very inefficient)
    - *If-Modified-Since* request header

## Forward proxy
- HTTP requests
  - Standard request in absolute-form to the proxy
  - The proxy will be the middle-point, forwarding the request towards the final termination
- Other (non-HTTP requests)
  - [HTTP tunneling](https://en.wikipedia.org/wiki/HTTP_tunnel)
  - [HTTP CONNECT](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods) request with absolute-form to the proxy
    - client ask The proxy **to establish and forward** the TCP connection and to become the middle-point
    - ![image](/images/CONNECT.PNG)
    - Only the initial connection request is HTTP; after that, the server simply proxies the established TCP connection
      - the proxy server continues to proxy **the TCP stream unmodified** to and from the client
    - Anything that uses a **two-way TCP connection** can be passed through a CONNECT tunnel
>*This is how* a client behind an HTTP proxy **can access websites using SSL or TLS** (i.e. HTTPS)

> - [RFC_7231](https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.6)
> - [TCP Tunneling in Web Proxies](https://datatracker.ietf.org/doc/html/draft-luotonen-web-proxy-tunneling-01)
> - [Method CONNECT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/CONNECT)

## SSL Forward/Anonymizer Proxy
- privacy shield between a client computer and the rest of the Internet
- hiding the client computer identifying information (IP address, firstly)
- Destination server sees requests coming from the proxy address rather than the actual client IP address
  - Typical use for accessing restricted content (like The pirate bay and similar)
- How it works? $\rightarrowtail$ [SSL Forward proxy ref.](https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/decryption/decryption-concepts/ssl-forward-proxy)
![image](/images/sslProxy.png)
  - The proxy *uses certificates* to establish itself **as a trusted third party** to the session between the client and the server
  - As the proxy continues to receive SSL traffic from the server that is destined for the client, it decrypts the SSL traffic into clear text traffic and applies decryption and security profiles to the traffic
  - **The proxy, then, re-encrypts** and forwards the traffic to the client
  - as in the image proxy has established **2 SSL sessions** for each side of the communication
    - What about trust? you need to trust proxy

## Reverse Proxy
> operates on behalf of the server

|Typical functions|||
|--|--|--|
|Load balancing|Cache static content|Compression|
|Accessing several servers into the same URL space|internal server protection|Application level controls|
|TLS acceleration|||

It receives the requests from the outside as if it were the server: 
- *forwards the request to the actual destination (origin) server*
- internal Server protection:
  - No direct connection with the outside also means *defense against DoS*
  - Can provide *support for HTTPS* to servers that only have HTTP
  - Can clean requests: *defense against SQL injections*
     - **WAF (Web Application Firewall)** inspects the HTTP traffic and prevents attacks, such as SQL injection, cross-site scripting (XSS),file inclusion, and other types of security issues
     - It can **block application** input/output from detected intrusions or malformed communication
     - **block contents** that violate policies
     - I**t can detect whether an unwanted protocol** is being provided through **on a non-standard port**
     - It can detect whether **a protocol is being abused** in any harmful way
  -  Can add AAA to services that do not have them
     -  Ex. [a iot Device](https://tinkerman.cat/post/secure-remote-access-to-your-iot-devices) behind a firewall that must be accessible from the Internet

### Manage SSL/TLS on Proxies
The SSL/TLS "handshake" process uses digital certificates based on asymmetric or public key encryption technology

Public key encryption is very secure, but also very processor-intensive (SSL bottlenecks)
- TLS acceleration:
  - SSL acceleration: use **hardware support** to perform modular operations with large operands
  - SSL offloading: use a **dedicated server** only for SSL handshake

- SSL offloading:
  - SSL termination: 
    - The proxy decrypts the TLS/SSL-encrypted data
    - then sends it on to the server *in an unencrypted state* 
      - This also allows IDS or application firewall inspection
  - SSL forwarding/Bridging: 
    - The proxy intercepts and decrypts TLS/SSL-encrypted traffic
    - *examines the contents* to ensure that it doesn't contain malicious code
    - then *re-encrypts it* before sending it on to the server
      - This only allows inspection of TLS/SSL-encrypted data before it reaches the server **to prevent application layer attacks** hidden inside

### SSL bump with HTTPS-Proxy
HTTPS traffic (fortunately) cannot be read,

What *if we WANT to read* a client HTTPS traffic?

***SSL bump***: We need to perform a Man-in-the-middle attack
- PRETEND to be the real server and be the termination of the SSL/TLS connection
- it consists in using the requested host name to dynamically *generate a server certificate* and *then impersonate* the named server

But: what if we don’t know the host name?
- Remember that we start the TLS handshake using an IP address and the hostname is sent in the HTTP request...
- If HTTPS is used, the SSL/TLS connection requires a certificate to be sent by the server, but...
  - *Which certificate* has to be sent?
  - Use the same certificate for all WebServers (NO!! Out of discussion)
  - The hostname is within the HTTP traffic *but it is encrypted* inside HTTPS
- then?
> ***TLS Handshake → BEFORE ANY HTTP packet***
> 
> Server Auth Before any other phase of TLS/HTTPS
>
> We need the Hostname in advance!  → Server Name Indication

### Server Name Indication (SNI)
Server Name Indication (SNI) is **an extension to TLS** 
> client indicates which hostname it is attempting to connect to at the start of the handshaking  process
- is it in clear Text
- [RFC3546](https://datatracker.ietf.org/doc/html/rfc3546#section-3.1)

![image](/images/SNI.PNG)

This allows a server to **present multiple certificates** on the same IP address and TCP port number and hence allows multiple secure (HTTPS) websites (or any other service over TLS) to be served by the same IP address **without requiring** all those sites **to use the same certificate**

### Encrypted SNI 
- An eavesdropper can see which site is being requested
- This helps security companies provide a filtering feature and governments implement censorship
  - Trick: [Domain Fronting](https://attack.mitre.org/techniques/T1090/004/)
    - In the SNI use the name of a CDN server 
    - then use a different host in the real HTTP request, always within the same CDN
- An upgrade called [**Encrypted SNI (ESNI)**](https://www.cloudflare.com/it-it/learning/ssl/what-is-encrypted-sni/) is being rolled out in an "experimental phase" to address this risk of domain eavesdropping
  - clear only after TLS established from the client

## SOCKS proxy
> similar to CONNECT Proxy ... but more versatile,
> It can relay ANY PROTOCOL: [SOCKS](https://en.wikipedia.org/wiki/SOCKS)

just enable same proxy but on every port available 
is a Circuit Level GW
implement a lot of things 

● Circuit level gateway

– Works at the session layer of the OSI model, or as a "shim-
layer" between the application layer and the transport

layer of the TCP/IP stack

● Similar to the HTTP CONNECT proxy
– A bit more versatile:
● Many authentication mechanisms
● Can tunnel TCP, but also UDP and IPv6 (SOCKS5)
● Can also work as a reverse proxy
● Implemented in SSH, putty and Tor


## Transparent proxy

