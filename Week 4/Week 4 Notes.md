# Pull before it gets taken down again:
[GitHub - BigBodyCobain/Shadowbroker: Open-source intelligence for the global theater. Track everything from the corporate/private jets of the wealthy, and spy satellites, to seismic events in one unified interface. Hook an AI agent up to have it parse through data and find previously unseen correlations. The knowledge is available to all but rarely aggregated in the open, until now. · GitHub](https://github.com/BigBodyCobain/Shadowbroker)

# Deception
human decision making cycle: 
	See, Think, Do
influence the cycle by following the cycle in reverse.
	- what do you want them to do?
	- what do they need think in order to follow through with it?
	- what do we have them see to trigger those thoughts?

# Pyramid of Pain
top - TTPs - 
middle - IPs - scanning
bottom - 
	Hashs - search for hash, use whitelsting
	IOCs -

# The Handoff Package
document the method for accessing the system well (msf payload, port, times, etc.)

---

# attacking a sliver server
```
──(kali㉿kali)-[~]
└─$ sudo nmap -sV -sS -sC --script="vuln" 10.1.10.196           
[sudo] password for kali: 
Starting Nmap 7.98 ( https://nmap.org ) at 2026-06-08 10:46 -0400
Nmap scan report for 10.1.10.196
Host is up (0.00012s latency).
Not shown: 994 closed tcp ports (reset)
PORT     STATE    SERVICE   VERSION
22/tcp   open     ssh       OpenSSH 10.2p1 Ubuntu 2ubuntu3.2 (Ubuntu Linux; protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:10.2p1: 
|       CVE-2026-35414  8.1     https://vulners.com/cve/CVE-2026-35414
|       CVE-2026-35386  8.1     https://vulners.com/cve/CVE-2026-35386
|       CVE-2026-35385  8.1     https://vulners.com/cve/CVE-2026-35385
|       CVE-2026-35387  6.5     https://vulners.com/cve/CVE-2026-35387
|_      CVE-2026-35388  2.5     https://vulners.com/cve/CVE-2026-35388
80/tcp   open     http      OpenResty web app server
|_http-server-header: openresty
| http-vuln-cve2011-3192: 
|   VULNERABLE:
|   Apache byterange filter DoS
|     State: VULNERABLE
|     IDs:  BID:49303  CVE:CVE-2011-3192
|       The Apache web server is vulnerable to a denial of service attack when numerous
|       overlapping byte ranges are requested.
|     Disclosure date: 2011-08-19
|     References:
|       https://seclists.org/fulldisclosure/2011/Aug/175
|       https://www.securityfocus.com/bid/49303
|       https://www.tenable.com/plugins/nessus/55976
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
81/tcp   open     http      OpenResty web app server
|_http-majordomo2-dir-traversal: ERROR: Script execution failed (use -d to debug)
|_http-vuln-cve2017-1001000: ERROR: Script execution failed (use -d to debug)
| http-vuln-cve2011-3192: 
|   VULNERABLE:
|   Apache byterange filter DoS
|     State: VULNERABLE
|     IDs:  BID:49303  CVE:CVE-2011-3192
|       The Apache web server is vulnerable to a denial of service attack when numerous
|       overlapping byte ranges are requested.
|     Disclosure date: 2011-08-19
|     References:
|       https://seclists.org/fulldisclosure/2011/Aug/175
|       https://www.securityfocus.com/bid/49303
|       https://www.tenable.com/plugins/nessus/55976
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-internal-ip-disclosure: 
|_  Internal IP Leaked: 172.18.0.2
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-server-header: openresty
443/tcp  open     ssl/https openresty
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-server-header: openresty
5000/tcp filtered upnp
8080/tcp open     http      Jetty 10.0.18
|_http-server-header: Jetty(10.0.18)
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-enum: 
|_  /robots.txt: Robots file
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
MAC Address: 00:0C:29:44:71:1C (VMware)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 116.73 seconds

```

