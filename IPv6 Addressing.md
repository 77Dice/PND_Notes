# IPv6 Addressing
## Benefits of IPv6  
- not a new protocol (late 1990s)
- Solve IPv4 shortage of Addresses (**128-bit address space**, written in hexadecimal)
- Stateless Configuration and DHCPv6 Stateful
- End-to-End reachability **without private addresses** and **NAT** (not a security feature)
- Better support for mobility: [RFC6275](https://datatracker.ietf.org/doc/html/rfc3775)
- Peer-to-Peer networking easier to create and maintain + more robust QOS and VOIP

--> IPv6 **Source** is always ``a Unicast`` || IPv6 **Destination** can be ``Unicast, Multicast or Anycast``

Mark *italic text* with one asterisk, **bold text** with two.
For ``monospaced text``, use two "backquotes" instead

## Hex and IPv6 Address Representation
<p align = "center" >
<img width="549" alt="IPv6_types" src="https://user-images.githubusercontent.com/101717315/159255943-8fd5d9c4-a366-48e2-8c11-fcb00214b3b1.png">
</p>

- IPv6 addresses are **128-bit** divided in **$(8\ X\ 16-bit)$** segments or **hextets** in range [0000:FFFF]
- Represented as **Hexadecimal digits**:**$(1\ hex\ digit=4\ Binary\ bits)$ separated by ":"
	\end{itemize}
	\subparagraph{Compressing IPv6 Addresses Rules:}
	\begin{enumerate}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item \textbf{Leading} zeros in any segment do not have to be written , \textbf{tailing} zeros must be included
		\item Any single,\textbf{contiguous segment} of all zeros can be represented with double colon "::"
	\end{enumerate}
			
	\paragraph{\large IPv6 Global Unicast Address (GUA)}	
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item GUA is identified as \textbf{2000::/3} up to \textbf{3FFF::/3} (\textit{first 3 binary bits of first hextet} 2000 $ \rightarrow $ \textbf{001}0)
		\item Globally \textbf{Unique and routable} as IPv4 public addresses ; 1/8th of all address space
		\item \textbf{2001:DB8::/32} are reserved for documentation
		\item All end users will have a global Unicast address					
		
		\begin{figure}[h!]
			\includegraphics[scale=1]{IPv6_addr_notation}
			\centering
			\caption{IPv6 Address Notation}
		\end{figure}
			
		\item Given a \textbf{Global Routing Prefix} we can \textbf{subnet} with \textbf{1 hextet} creating up to 65k subnets:
		
		\begin{itemize}
			\setlength{\itemsep}{-3pt}
			\item \textbf{Prefix:} equivalent to \textit{Network address} of IPv4
			\item \textbf{Prefix length:} equivalent to \textit{subnet mask} of IPv4
			\item \textbf{Interface ID:} equivalent to \textit{host portion} of an IPv4 address
			\item we use \textbf{3-1-4 rule} for divide a GUA into \textbf{IPv6 /64 local networks} as shown:
		\end{itemize}
		\begin{figure}[h]
			\includegraphics[scale=0.8]{3-1-4 rule}
			\centering
			\caption{3-1-4 Rule for /64 Nets}
		\end{figure}
	\end{itemize}

\newpage

	\paragraph{\large IPv6 Link-Local Unicast Addresses}
		\begin{itemize}
			\vspace{-3mm}
			\setlength{\itemsep}{-3pt}
			\item \textit{ll} is identified as \textbf{FE80::/10} up to \textbf{FEBF::/10} (\textit{first 10 binary bits of first 3 hextets})
			\item \textit{FE80:: $ \rightarrow $\textbf{1111 1110 10}00 0000} $ \implies $ \textit{FEBF:: $ \rightarrow $ \textbf{1111 1110 10}11 1111}
			\item Used to communicate with other devices \textbf{on the link} then \textbf{Not Routable}
			\item \textbf{Only have to be unique on the link} (Network segment-internal lan)
			\item \textbf{every IPv6 device} must have \textbf{at least} a Link-local address
		\end{itemize}
	They are usually created \textbf{Automatically} and statically for Routers:
		\begin{itemize}
			\vspace{-3mm}
			\setlength{\itemsep}{-3pt}
			\item there are two ways for construct the \textbf{Interface ID:}
			\begin{itemize}
				\vspace{-3mm}
				\setlength{\itemsep}{-3pt}
				\item \textbf{Random 64 bits} for many hosts
				\item Extended unique Identifier 64 \href{https://community.cisco.com/t5/networking-documents/understanding-ipv6-eui-64-bit-address/ta-p/3116953}{(\textbf{EUI-64})	}
			\end{itemize} 
		\end{itemize}
	\begin{figure}[h]
		\vspace{-5mm}
		\includegraphics[scale=0.8]{LL addr}
		\centering
		\caption{Link-Local Unicast Address}
	\end{figure}
	\vspace{-5mm}
	\subparagraph{EUI-64}Starting from a 48-bit MAC address
	\begin{enumerate}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item the MAC address is separated into \textbf{two 24-bits} called OUI(Organizationally Unique Identifier) and the Device Identifier 
		\item  The 16-bit hextet \textbf{0xFFFE} is then inserted between the two 24-bits parts
		\item then the \textbf{seventh bit} from the left or the \textbf{Universal/local(U/L) bit} is flipped:		
	\end{enumerate}		
	\subparagraph{Why we use Link-local Addresses?}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item[$\rightarrow$] Used as \textbf{Source IPv6 Address} before a device gets one dynamically (SLAAC || DHCPv6)
		\item[$\rightarrow$] Router's link-local address is used by devices as \textbf{default gateway} 
		\item[$\rightarrow$] uses by Routers for exchange \textbf{routing messages}
		\item[$\rightarrow$] uses by Routers as the \textbf{next-hop address} in the routing table 
	\end{itemize}
	Link-Local addresses have an \textbf{Important role} in IPv6
	\begin{figure}[h]
		\includegraphics[scale=0.8]{multicast}
		\centering
		\vspace{-15mm}
		\caption{Multicast Address}
	\end{figure}
	\vspace{-5mm}
	\paragraph{\large IPv6 Multicast Addresses}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item How send single packet \textbf{to multiple destinations} simultaneously? (one-to-many)
		\item exists two types of Multicast addresses:
		\begin{itemize}
			\vspace{-3mm}
			\setlength{\itemsep}{-3pt}
			\item Assigned as \textbf{FF00::/8} up to \textbf{FFFF::/8} (\textit{first 8 binary bits of first 2 hextets})
			\item \textit{FF00:: $\rightarrow$\textbf{1111 1111} 0000 0000 $\implies$ FFFF:: $\rightarrow$ \textbf{1111 1111} 1111 1111}
			\item Solicited-Node as \textbf{FF02::1:FF00:0000/104}
			\item \textit{generated from \textbf{least-significant 24-bits} of Uni/Anycast address}
			\item used for the Neighbor Discovery Protocol(NDP): \href{https://en.wikipedia.org/wiki/Solicited-node_multicast_address}{Wiki to Solicited-node Address Ex.}
		\end{itemize}	
	\end{itemize}
	\vspace{-6mm}
	\subparagraph{Scope} 4-bit field that define the \textbf{range} of the Multicast packet:\\ inside Broadcast domain(2), all $eth_{x}$ of one router + need to be Enabled(5) 
	\begin{figure}[ht]
		\centering
		\begin{tabular}{||c|c|c|c||}
			\hline
			Reserved & 0 & Interface-Local & 1 \\
			\hline
			Link-Local & 2 & Site-Local & 5 \\
			\hline
			Organization-Local & 8 & Global & E \\
			\hline
		\end{tabular}
	\end{figure}
	\vspace{-6mm}				
	\subparagraph{Flag}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item[0:] \textbf{Permanent} for \href{https://www.ciscopress.com/articles/article.asp?p=2803866&seqNum=5}{well-known Multicast addresses} assigned by IANA
		\item[1:] \textbf{Non-permanently-assigned} "dynamically" assigned  
	\end{itemize}
	\vspace{-5mm}
	\subparagraph{Well-known Assigned IPv6 Multicast Addresses}
	\href{https://www.iana.org/assignments/ipv6-multicast-addresses/ipv6-multicast-addresses.xhtml}{IANA-Reference}\\
	\begin{figure}[h]
		\vspace{-10mm}
		\includegraphics[scale=0.8]{multi-ll}
		\centering		
		\caption{Link-local scope Assigned MultiCast Addresses}
		\includegraphics[scale=0.8]{multi-5}
		\centering		
		\caption{Site-local scope Assigned MultiCast Addresses}		
	\end{figure}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item \underline{All IPv6 Devices:} \textbf{FF02::1} All devices including the router
		\item every IPv6 device will listen and process packets
		\item More efficient than Broadcast  
	\end{itemize}
	\begin{figure}[h]
		\vspace{-7mm}
		\includegraphics[scale=0.8]{ROuterAdv}
		\centering		
		\caption{Router Advertisement}		
	\end{figure}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item \underline{All IPv6 Routers:} \textbf{FF02::2} All Routers
		\item Used by devices to communicate with IPv6 Router
	\end{itemize}
	\begin{figure}[h]
		\vspace{-7mm}
		\includegraphics[scale=0.8]{ROuterSol}
		\centering		
		\caption{Router Solicitation}		
	\end{figure}
	\paragraph{\large Stateless Address Autoconfiguration - SLAAC}
	\begin{itemize}
		\vspace{-3mm}
		\setlength{\itemsep}{-3pt}
		\item \textbf{NO Full knowledge} of network state: no complete list of used addresses
		\item 
		\item from SLIDE 05 44 to the end!!
		\item ICMPv6 NDP
		\item Dynamic Address Allocation 3 Options
	\end{itemize}
	awdawdawd
	
	
