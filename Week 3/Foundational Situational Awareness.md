## Flags:
 - Processes: QUARTZ-VEIL
 - Services: SIGNAL-HARBOR
 - Scheduled Tasks: IRON-LANTERN
 - User/Priv Context: VELVET-ANCHOR
 - files: COBALT-TRACE

## Systeminfo
```
unset histfile
export histsize=0
export histfilesize=0

badguy@boar-11:/home/svc_backup$ sudo -l
[sudo] password for badguy: 
Matching Defaults entries for badguy on boar-11:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin\:/opt/puppetlabs/bin

User badguy may run the following commands on boar-11:
    (ALL : ALL) ALL

sudo -i

badguy@boar-11:~$ whoami
badguy

badguy@boar-11:~$ uname -a
`Linux boar-11 5.4.0-135-generic #152-Ubuntu SMP Wed Nov 23 20:19:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

badguy@boar-11:~$ man init | head
SYSTEMD(1)                                                                                                      systemd                                                                                                      SYSTEMD(1)

NAME
       systemd, init - systemd system and service manager

SYNOPSIS
       /lib/systemd/systemd [OPTIONS...]

       init [OPTIONS...] {COMMAND}
```

## Processes
```

badguy@boar-11:~$ ps -lef
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 S root       28094   28093  0  80   0 -  1723 -      11:35 ?        00:00:00 /bin/bash -c env PROCESS_FLAG="IRON-LANTERN" sleep 90 || true
```

## Services
```
badguy@boar-11:/home$ sudo netstat -putan
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:36963         0.0.0.0:*               LISTEN      1026/containerd     
tcp        0      0 127.0.0.1:8081          0.0.0.0:*               LISTEN      1406/apache2        
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      704/systemd-resolve 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1185/sshd: /usr/sbi 
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      3091/cupsd          
tcp        0    196 20.30.40.11:22          80.90.100.10:39668      ESTABLISHED 26263/sshd: badguy  
tcp6       0      0 :::5000                 :::*                    LISTEN      1014/docker-registr 
tcp6       0      0 :::80                   :::*                    LISTEN      1406/apache2        
tcp6       0      0 :::22                   :::*                    LISTEN      1185/sshd: /usr/sbi 
tcp6       0      0 ::1:631                 :::*                    LISTEN      3091/cupsd          
udp        0      0 127.0.0.53:53           0.0.0.0:*                           704/systemd-resolve 
udp        0      0 10.10.20.11:68          0.0.0.0:*                           466/systemd-network 
udp        0      0 20.30.40.11:68          0.0.0.0:*                           466/systemd-network 
udp        0      0 20.30.40.11:123         0.0.0.0:*                           1038/ntpd           
udp        0      0 10.10.20.11:123         0.0.0.0:*                           1038/ntpd           
udp        0      0 127.0.0.1:123           0.0.0.0:*                           1038/ntpd           
udp        0      0 0.0.0.0:123             0.0.0.0:*                           1038/ntpd           
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           884/avahi-daemon: r 
udp        0      0 0.0.0.0:44312           0.0.0.0:*                           884/avahi-daemon: r 
udp        0      0 0.0.0.0:631             0.0.0.0:*                           3092/cups-browsed   
udp6       0      0 fe80::202:b3ff:fe00:123 :::*                                1038/ntpd           
udp6       0      0 fe80::202:b3ff:fe00:123 :::*                                1038/ntpd           
udp6       0      0 ::1:123                 :::*                                1038/ntpd           
udp6       0      0 :::123                  :::*                                1038/ntpd           
udp6       0      0 :::5353                 :::*                                884/avahi-daemon: r 
udp6       0      0 :::35553                :::*                                884/avahi-daemon: r 


]0;badguy@boar-11: ~[01;32mbadguy@boar-11[00m:[01;34m~[00m$ cat /etc/services 
# Network services, Internet style
#
# Note that it is presently the policy of IANA to assign a single well-known
# port number for both TCP and UDP; hence, officially ports have two entries
# even if the protocol doesn't support UDP operations.
#
# Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
#
# New ports will be added on request if they have been officially assigned
# by IANA and used in the real-world or are needed by a debian package.
# If you need a huge list of used numbers please install the nmap package.

tcpmux		1/tcp				# TCP port service multiplexer
echo		7/tcp
echo		7/udp
discard		9/tcp		sink null
discard		9/udp		sink null
systat		11/tcp		users
daytime		13/tcp
daytime		13/udp
netstat		15/tcp
qotd		17/tcp		quote
chargen		19/tcp		ttytst source
chargen		19/udp		ttytst source
ftp-data	20/tcp
ftp		21/tcp
fsp		21/udp		fspd
ssh		22/tcp				# SSH Remote Login Protocol
telnet		23/tcp
smtp		25/tcp		mail
time		37/tcp		timserver
time		37/udp		timserver
whois		43/tcp		nicname
tacacs		49/tcp				# Login Host Protocol (TACACS)
tacacs		49/udp
domain		53/tcp				# Domain Name Server
domain		53/udp
bootps		67/udp
bootpc		68/udp
tftp		69/udp
gopher		70/tcp				# Internet Gopher
finger		79/tcp
http		80/tcp		www		# WorldWideWeb HTTP
kerberos	88/tcp		kerberos5 krb5 kerberos-sec	# Kerberos v5
kerberos	88/udp		kerberos5 krb5 kerberos-sec	# Kerberos v5
iso-tsap	102/tcp		tsap		# part of ISODE
acr-nema	104/tcp		dicom		# Digital Imag. & Comm. 300
pop3		110/tcp		pop-3		# POP version 3
sunrpc		111/tcp		portmapper	# RPC 4.0 portmapper
sunrpc		111/udp		portmapper
auth		113/tcp		authentication tap ident
nntp		119/tcp		readnews untp	# USENET News Transfer Protocol
ntp		123/udp				# Network Time Protocol
epmap		135/tcp		loc-srv		# DCE endpoint resolution
netbios-ns	137/tcp				# NETBIOS Name Service
netbios-ns	137/udp
netbios-dgm	138/tcp				# NETBIOS Datagram Service
netbios-dgm	138/udp
netbios-ssn	139/tcp				# NETBIOS session service
netbios-ssn	139/udp
imap2		143/tcp		imap		# Interim Mail Access P 2 and 4
snmp		161/tcp				# Simple Net Mgmt Protocol
snmp		161/udp
snmp-trap	162/tcp		snmptrap	# Traps for SNMP
snmp-trap	162/udp		snmptrap
cmip-man	163/tcp				# ISO mgmt over IP (CMOT)
cmip-man	163/udp
cmip-agent	164/tcp
cmip-agent	164/udp
mailq		174/tcp			# Mailer transport queue for Zmailer
xdmcp		177/udp			# X Display Manager Control Protocol
bgp		179/tcp				# Border Gateway Protocol
smux		199/tcp				# SNMP Unix Multiplexer
qmtp		209/tcp				# Quick Mail Transfer Protocol
z3950		210/tcp		wais		# NISO Z39.50 database
ipx		213/udp				# IPX [RFC1234]
ptp-event	319/udp
ptp-general	320/udp
pawserv		345/tcp				# Perf Analysis Workbench
zserv		346/tcp				# Zebra server
rpc2portmap	369/tcp
rpc2portmap	369/udp				# Coda portmapper
codaauth2	370/tcp
codaauth2	370/udp				# Coda authentication server
clearcase	371/udp		Clearcase
ldap		389/tcp			# Lightweight Directory Access Protocol
ldap		389/udp
svrloc		427/tcp				# Server Location
svrloc		427/udp
https		443/tcp				# http protocol over TLS/SSL
snpp		444/tcp				# Simple Network Paging Protocol
microsoft-ds	445/tcp				# Microsoft Naked CIFS
microsoft-ds	445/udp
kpasswd		464/tcp
kpasswd		464/udp
submissions	465/tcp		ssmtp smtps urd # Submission over TLS [RFC8314]
saft		487/tcp			# Simple Asynchronous File Transfer
isakmp		500/udp				# IPSEC key management
rtsp		554/tcp			# Real Time Stream Control Protocol
rtsp		554/udp
nqs		607/tcp				# Network Queuing system
asf-rmcp	623/udp		# ASF Remote Management and Control Protocol
qmqp		628/tcp
ipp		631/tcp				# Internet Printing Protocol
#
# UNIX specific services
#
exec		512/tcp
biff		512/udp		comsat
login		513/tcp
who		513/udp		whod
shell		514/tcp		cmd syslog	# no passwords used
syslog		514/udp
printer		515/tcp		spooler		# line printer spooler
talk		517/udp
ntalk		518/udp
route		520/udp		router routed	# RIP
gdomap		538/tcp				# GNUstep distributed objects
gdomap		538/udp
uucp		540/tcp		uucpd		# uucp daemon
klogin		543/tcp				# Kerberized `rlogin' (v5)
kshell		544/tcp		krcmd		# Kerberized `rsh' (v5)
dhcpv6-client	546/udp
dhcpv6-server	547/udp
afpovertcp	548/tcp				# AFP over TCP
nntps		563/tcp		snntp		# NNTP over SSL
submission	587/tcp				# Submission [RFC4409]
ldaps		636/tcp				# LDAP over SSL
ldaps		636/udp
tinc		655/tcp				# tinc control port
tinc		655/udp
silc		706/tcp
kerberos-adm	749/tcp				# Kerberos `kadmin' (v5)
#
domain-s	853/tcp				# DNS over TLS [RFC7858]
domain-s	853/udp				# DNS over DTLS [RFC8094]
rsync		873/tcp
ftps-data	989/tcp				# FTP over SSL (data)
ftps		990/tcp
telnets		992/tcp				# Telnet over SSL
imaps		993/tcp				# IMAP over SSL
pop3s		995/tcp				# POP-3 over SSL
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
socks		1080/tcp			# socks proxy server
proofd		1093/tcp
rootd		1094/tcp
openvpn		1194/tcp
openvpn		1194/udp
rmiregistry	1099/tcp			# Java RMI Registry
lotusnote	1352/tcp	lotusnotes	# Lotus Note
ms-sql-s	1433/tcp			# Microsoft SQL Server
ms-sql-s	1433/udp
ms-sql-m	1434/tcp			# Microsoft SQL Monitor
ms-sql-m	1434/udp
ingreslock	1524/tcp
datametrics	1645/tcp	old-radius
datametrics	1645/udp	old-radius
sa-msg-port	1646/tcp	old-radacct
sa-msg-port	1646/udp	old-radacct
kermit		1649/tcp
groupwise	1677/tcp
l2f		1701/udp	l2tp
radius		1812/tcp
radius		1812/udp
radius-acct	1813/tcp	radacct		# Radius Accounting
radius-acct	1813/udp	radacct
cisco-sccp	2000/tcp			# Cisco SCCP
nfs		2049/tcp			# Network File System
nfs		2049/udp			# Network File System
gnunet		2086/tcp
gnunet		2086/udp
rtcm-sc104	2101/tcp			# RTCM SC-104 IANA 1/29/99
rtcm-sc104	2101/udp
gsigatekeeper	2119/tcp
gris		2135/tcp		# Grid Resource Information Server
cvspserver	2401/tcp			# CVS client/server operations
venus		2430/tcp			# codacon port
venus		2430/udp			# Venus callback/wbc interface
venus-se	2431/tcp			# tcp side effects
venus-se	2431/udp			# udp sftp side effect
codasrv		2432/tcp			# not used
codasrv		2432/udp			# server port
codasrv-se	2433/tcp			# tcp side effects
codasrv-se	2433/udp			# udp sftp side effect
mon		2583/tcp			# MON traps
mon		2583/udp
dict		2628/tcp			# Dictionary server
f5-globalsite	2792/tcp
gsiftp		2811/tcp
gpsd		2947/tcp
gds-db		3050/tcp	gds_db		# InterBase server
icpv2		3130/tcp	icp		# Internet Cache Protocol
icpv2		3130/udp	icp
isns		3205/tcp			# iSNS Server Port
isns		3205/udp			# iSNS Server Port
iscsi-target	3260/tcp
mysql		3306/tcp
ms-wbt-server	3389/tcp
nut		3493/tcp			# Network UPS Tools
nut		3493/udp
distcc		3632/tcp			# distributed compiler
distcc		3632/udp
daap		3689/tcp			# Digital Audio Access Protocol
daap		3689/udp
svn		3690/tcp	subversion	# Subversion protocol
svn		3690/udp	subversion
suucp		4031/tcp			# UUCP over SSL
suucp		4031/udp
sysrqd		4094/tcp			# sysrq daemon
sysrqd		4094/udp
sieve		4190/tcp			# ManageSieve Protocol
epmd		4369/tcp			# Erlang Port Mapper Daemon
epmd		4369/udp
remctl		4373/tcp		# Remote Authenticated Command Service
remctl		4373/udp
f5-iquery	4353/tcp			# F5 iQuery
f5-iquery	4353/udp
ipsec-nat-t	4500/udp			# IPsec NAT-Traversal [RFC3947]
iax		4569/tcp			# Inter-Asterisk eXchange
iax		4569/udp
mtn		4691/tcp			# monotone Netsync Protocol
mtn		4691/udp
radmin-port	4899/tcp			# RAdmin Port
radmin-port	4899/udp
sip		5060/tcp			# Session Initiation Protocol
sip		5060/udp
sip-tls		5061/tcp
sip-tls		5061/udp
xmpp-client	5222/tcp	jabber-client	# Jabber Client Connection
xmpp-server	5269/tcp	jabber-server	# Jabber Server Connection
cfengine	5308/tcp
mdns		5353/udp			# Multicast DNS
postgresql	5432/tcp	postgres	# PostgreSQL Database
freeciv		5556/tcp	rptp		# Freeciv gameplay
amqps		5671/tcp			# AMQP protocol over TLS/SSL
amqp		5672/tcp
amqp		5672/udp
amqp		5672/sctp
x11		6000/tcp	x11-0		# X Window System
x11-1		6001/tcp
x11-2		6002/tcp
x11-3		6003/tcp
x11-4		6004/tcp
x11-5		6005/tcp
x11-6		6006/tcp
x11-7		6007/tcp
gnutella-svc	6346/tcp			# gnutella
gnutella-svc	6346/udp
gnutella-rtr	6347/tcp			# gnutella
gnutella-rtr	6347/udp
sge-qmaster	6444/tcp	sge_qmaster	# Grid Engine Qmaster Service
sge-execd	6445/tcp	sge_execd	# Grid Engine Execution Service
mysql-proxy	6446/tcp			# MySQL Proxy
babel		6696/udp			# Babel Routing Protocol
ircs-u		6697/tcp		# Internet Relay Chat via TLS/SSL
afs3-fileserver 7000/tcp	bbs		# file server itself
afs3-fileserver 7000/udp	bbs
afs3-callback	7001/tcp			# callbacks to cache managers
afs3-callback	7001/udp
afs3-prserver	7002/tcp			# users & groups database
afs3-prserver	7002/udp
afs3-vlserver	7003/tcp			# volume location database
afs3-vlserver	7003/udp
afs3-kaserver	7004/tcp			# AFS/Kerberos authentication
afs3-kaserver	7004/udp
afs3-volser	7005/tcp			# volume managment server
afs3-volser	7005/udp
afs3-errors	7006/tcp			# error interpretation service
afs3-errors	7006/udp
afs3-bos	7007/tcp			# basic overseer process
afs3-bos	7007/udp
afs3-update	7008/tcp			# server-to-server updater
afs3-update	7008/udp
afs3-rmtsys	7009/tcp			# remote cache manager service
afs3-rmtsys	7009/udp
font-service	7100/tcp	xfs		# X Font Service
http-alt	8080/tcp	webcache	# WWW caching service
puppet		8140/tcp			# The Puppet master service
bacula-dir	9101/tcp			# Bacula Director
bacula-fd	9102/tcp			# Bacula File Daemon
bacula-sd	9103/tcp			# Bacula Storage Daemon
xmms2		9667/tcp	# Cross-platform Music Multiplexing System
nbd		10809/tcp			# Linux Network Block Device
zabbix-agent	10050/tcp			# Zabbix Agent
zabbix-trapper	10051/tcp			# Zabbix Trapper
amanda		10080/tcp			# amanda backup services
dicom		11112/tcp
hkp		11371/tcp			# OpenPGP HTTP Keyserver
db-lsp		17500/tcp			# Dropbox LanSync Protocol
dcap		22125/tcp			# dCache Access Protocol
gsidcap		22128/tcp			# GSI dCache Access Protocol
wnn6		22273/tcp			# wnn6

#
# Datagram Delivery Protocol services
#
rtmp		1/ddp			# Routing Table Maintenance Protocol
nbp		2/ddp			# Name Binding Protocol
echo		4/ddp			# AppleTalk Echo Protocol
zip		6/ddp			# Zone Information Protocol

#=========================================================================
# The remaining port numbers are not as allocated by IANA.
#=========================================================================

# Kerberos (Project Athena/MIT) services
kerberos4	750/udp		kerberos-iv kdc	# Kerberos (server)
kerberos4	750/tcp		kerberos-iv kdc
kerberos-master	751/udp		kerberos_master	# Kerberos authentication
kerberos-master	751/tcp
passwd-server	752/udp		passwd_server	# Kerberos passwd server
krb-prop	754/tcp		krb_prop krb5_prop hprop # Kerberos slave propagation
zephyr-srv	2102/udp			# Zephyr server
zephyr-clt	2103/udp			# Zephyr serv-hm connection
zephyr-hm	2104/udp			# Zephyr hostmanager
iprop		2121/tcp			# incremental propagation
supfilesrv	871/tcp			# Software Upgrade Protocol server
supfiledbg	1127/tcp		# Software Upgrade Protocol debugging

#
# Services added for the Debian GNU/Linux distribution
#
poppassd	106/tcp				# Eudora
poppassd	106/udp
moira-db	775/tcp		moira_db	# Moira database
moira-update	777/tcp		moira_update	# Moira update protocol
moira-ureg	779/udp		moira_ureg	# Moira user registration
spamd		783/tcp				# spamassassin daemon
skkserv		1178/tcp			# skk jisho server port
predict		1210/udp			# predict -- satellite tracking
rmtcfg		1236/tcp			# Gracilis Packeten remote config server
xtel		1313/tcp			# french minitel
xtelw		1314/tcp			# french minitel
support		1529/tcp			# GNATS
cfinger		2003/tcp			# GNU Finger
frox		2121/tcp			# frox: caching ftp proxy
zebrasrv	2600/tcp			# zebra service
zebra		2601/tcp			# zebra vty
ripd		2602/tcp			# ripd vty (zebra)
ripngd		2603/tcp			# ripngd vty (zebra)
ospfd		2604/tcp			# ospfd vty (zebra)
bgpd		2605/tcp			# bgpd vty (zebra)
ospf6d		2606/tcp			# ospf6d vty (zebra)
ospfapi		2607/tcp			# OSPF-API
isisd		2608/tcp			# ISISd vty (zebra)
afbackup	2988/tcp			# Afbackup system
afbackup	2988/udp
afmbackup	2989/tcp			# Afmbackup system
afmbackup	2989/udp
fax		4557/tcp			# FAX transmission service (old)
hylafax		4559/tcp			# HylaFAX client-server protocol (new)
distmp3		4600/tcp			# distmp3host daemon
munin		4949/tcp	lrrd		# Munin
enbd-cstatd	5051/tcp			# ENBD client statd
enbd-sstatd	5052/tcp			# ENBD server statd
pcrd		5151/tcp			# PCR-1000 Daemon
noclog		5354/tcp			# noclogd with TCP (nocol)
noclog		5354/udp			# noclogd with UDP (nocol)
hostmon		5355/tcp			# hostmon uses TCP (nocol)
hostmon		5355/udp			# hostmon uses UDP (nocol)
rplay		5555/udp			# RPlay audio service
nrpe		5666/tcp			# Nagios Remote Plugin Executor
nsca		5667/tcp			# Nagios Agent - NSCA
mrtd		5674/tcp			# MRT Routing Daemon
bgpsim		5675/tcp			# MRT Routing Simulator
canna		5680/tcp			# cannaserver
syslog-tls	6514/tcp			# Syslog over TLS [RFC5425]
sane-port	6566/tcp	sane saned	# SANE network scanner daemon
ircd		6667/tcp			# Internet Relay Chat
zope-ftp	8021/tcp			# zope management by ftp
tproxy		8081/tcp			# Transparent Proxy
omniorb		8088/tcp			# OmniORB
omniorb		8088/udp
clc-build-daemon 8990/tcp			# Common lisp build daemon
xinetd		9098/tcp
mandelspawn	9359/udp	mandelbrot	# network mandelbrot
git		9418/tcp			# Git Version Control System
zope		9673/tcp			# zope server
webmin		10000/tcp
kamanda		10081/tcp			# amanda backup services (Kerberos)
amandaidx	10082/tcp			# amanda backup services
amidxtape	10083/tcp			# amanda backup services
smsqp		11201/tcp			# Alamin SMS gateway
smsqp		11201/udp
xpilot		15345/tcp			# XPilot Contact Port
xpilot		15345/udp
sgi-cmsd	17001/udp		# Cluster membership services daemon
sgi-crsd	17002/udp
sgi-gcd		17003/udp			# SGI Group membership daemon
sgi-cad		17004/tcp			# Cluster Admin daemon
isdnlog		20011/tcp			# isdn logging system
isdnlog		20011/udp
vboxd		20012/tcp			# voice box system
vboxd		20012/udp
binkp		24554/tcp			# binkp fidonet protocol
asp		27374/tcp			# Address Search Protocol
asp		27374/udp
csync2		30865/tcp			# cluster synchronization tool
dircproxy	57000/tcp			# Detachable IRC Proxy
tfido		60177/tcp			# fidonet EMSI over telnet
fido		60179/tcp			# fidonet EMSI over TCP

# Local services

badguy@boar-11:~$ ls -la /etc/init.d
total 308
drwxr-xr-x   2 root root  4096 May 29 10:16 .
drwxr-xr-x 148 root root 12288 May 29 10:16 ..
-rwxr-xr-x   1 root root  2269 Nov 28  2019 acpid
-rwxr-xr-x   1 root root  5574 Nov  5  2019 alsa-utils
-rwxr-xr-x   1 root root  2055 Jul 16  2019 anacron
-rwxr-xr-x   1 root root  8181 Mar 18  2024 apache2
-rwxr-xr-x   1 root root  2489 Mar 18  2024 apache-htcacheclean
-rwxr-xr-x   1 root root  3740 Apr  1  2020 apparmor
-rwxr-xr-x   1 root root  2915 Jun 29  2022 apport
-rwxr-xr-x   1 root root  1071 Jul 24  2018 atd
-rwxr-xr-x   1 root root  2401 Aug 21  2018 avahi-daemon
-rwxr-xr-x   1 root root  1597 Sep  5  2019 bgpd
-rwxr-xr-x   1 root root  2968 Feb 26  2020 bluetooth
-rwxr-xr-x   1 root root  1232 Mar 27  2020 console-setup.sh
-rwxr-xr-x   1 root root  3059 Feb 10  2020 cron
-rwxr-xr-x   1 root root   937 Feb  4  2020 cryptdisks
-rwxr-xr-x   1 root root   896 Feb  4  2020 cryptdisks-early
-rwxr-xr-x   1 root root  2804 Feb 17  2020 cups
-rwxr-xr-x   1 root root  1961 Apr 10  2020 cups-browsed
-rwxr-xr-x   1 root root  3152 Sep 30  2019 dbus
-rwxr-xr-x   1 root root  1543 Dec 16  2019 docker-registry
-rwxr-xr-x   1 root root  3033 Nov 10  2020 gdm3
-rwxr-xr-x   1 root root   985 Feb 12  2021 grub-common
-rwxr-xr-x   1 root root  3809 Jul 28  2019 hwclock.sh
-rwxr-xr-x   1 root root  2638 Dec 13  2019 irqbalance
-rwxr-xr-x   1 root root  1503 Apr  1  2019 iscsid
-rwxr-xr-x   1 root root  1608 Sep  5  2019 isisd
-rwxr-xr-x   1 root root  3131 May 19  2017 kerneloops
-rwxr-xr-x   1 root root  1479 Nov 27  2019 keyboard-setup.sh
-rwxr-xr-x   1 root root  2044 Feb 19  2020 kmod
-rwxr-xr-x   1 root root   695 Jan 27  2020 lvm2
-rwxr-xr-x   1 root root   586 Jan 27  2020 lvm2-lvmpolld
-rwxr-xr-x   1 root root  2827 Jan  9  2020 multipath-tools
-rwxr-xr-x   1 root root  4445 Jan 28  2019 networking
-rwxr-xr-x   1 root root  7730 Feb  6  2018 networking-routes
-rwxr-xr-x   1 root root  1942 Sep 16  2020 network-manager
-rwxr-xr-x   1 root root  1561 Nov 27  2020 ntp
-rwxr-xr-x   1 root root  2503 Apr  1  2019 open-iscsi
-rwxr-xr-x   1 root root  1846 Mar  9  2020 open-vm-tools
-rwxr-xr-x   1 root root  9138 Dec  3  2018 openvpn
-rwxr-xr-x   1 root root  1631 Sep  5  2019 ospf6d
-rwxr-xr-x   1 root root  1603 Sep  5  2019 ospfd
-rwxr-xr-x   1 root root  1607 Sep  5  2019 pimd
-rwxr-xr-x   1 root root  1366 Mar 23  2020 plymouth
-rwxr-xr-x   1 root root   752 Mar 23  2020 plymouth-log
-rwxr-xr-x   1 root root   612 Feb  8  2019 pppd-dns
-rwxr-xr-x   1 root root   924 Feb 13  2020 procps
-rwxr-xr-x   1 root root   469 Oct 15  2020 pulseaudio-enable-autospawn
-rwxr-xr-x   1 root root  3990 Jan  3  2020 resolvconf
-rwxr-xr-x   1 root root  1594 Sep  5  2019 ripd
-rwxr-xr-x   1 root root  1626 Sep  5  2019 ripngd
-rwxr-xr-x   1 root root  4417 Oct 14  2019 rsync
-rwxr-xr-x   1 root root  2864 Mar  7  2019 rsyslog
-rwxr-xr-x   1 root root  2224 Feb 11  2020 saned
-rwxr-xr-x   1 root root  1222 Apr  2  2017 screen-cleanup
-rwxr-xr-x   1 root root  2035 Jan 12  2020 speech-dispatcher
-rwxr-xr-x   1 root root  2484 Sep 27  2019 spice-vdagent
-rwxr-xr-x   1 root root  3939 May 29  2020 ssh
-rwxr-xr-x   1 root root  1227 Jun 10  2019 ubuntu-fan
-rwxr-xr-x   1 root root  6872 Apr 22  2020 udev
-rwxr-xr-x   1 root root  2083 Jan 21  2020 ufw
-rwxr-xr-x   1 root root  1391 Apr 13  2020 unattended-upgrades
-rwxr-xr-x   1 root root  1306 Apr  2  2020 uuidd
-rwxr-xr-x   1 root root  1466 Sep  5  2019 watchquagga
-rwxr-xr-x   1 root root   485 Aug 10  2018 whoopsie
-rwxr-xr-x   1 root root  2757 Jan 20  2017 x11-common
-rwxr-xr-x   1 root root  1618 Sep  5  2019 zebra

badguy@boar-11:/home$ systemctl status docker-registry.service 
● docker-registry.service - the Docker toolset to pack, ship, store, and deliver content
     Loaded: loaded (/lib/systemd/system/docker-registry.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2026-05-31 23:39:51 EDT; 13h ago
   Main PID: 1014 (docker-registry)
      Tasks: 10 (limit: 2268)
     Memory: 19.9M
     CGroup: /system.slice/docker-registry.service
             └─1014 /usr/bin/docker-registry serve /etc/docker/registry/config.yml

```
## User Context
```
badguy@boar-11:~$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin
syslog:x:104:110::/home/syslog:/usr/sbin/nologin
_apt:x:105:65534::/nonexistent:/usr/sbin/nologin
tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false
uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin
tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin
landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:110:1::/var/cache/pollinate:/bin/false
sshd:x:111:65534::/run/sshd:/usr/sbin/nologin
ntp:x:112:118::/nonexistent:/usr/sbin/nologin
dnsmasq:x:113:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
docker-registry:x:114:120:Docker Registry,,,:/var/lib/docker-registry:/usr/sbin/nologin
kernoops:x:115:65534:Kernel Oops Tracking Daemon,,,:/:/usr/sbin/nologin
cups-pk-helper:x:116:121:user for cups-pk-helper service,,,:/home/cups-pk-helper:/usr/sbin/nologin
rtkit:x:117:123:RealtimeKit,,,:/proc:/usr/sbin/nologin
whoopsie:x:118:124::/nonexistent:/bin/false
geoclue:x:119:125::/var/lib/geoclue:/usr/sbin/nologin
avahi-autoipd:x:120:127:Avahi autoip daemon,,,:/var/lib/avahi-autoipd:/usr/sbin/nologin
usbmux:x:121:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
avahi:x:122:128:Avahi mDNS daemon,,,:/var/run/avahi-daemon:/usr/sbin/nologin
saned:x:123:130::/var/lib/saned:/usr/sbin/nologin
nm-openvpn:x:124:131:NetworkManager OpenVPN,,,:/var/lib/openvpn/chroot:/usr/sbin/nologin
colord:x:125:132:colord colour management daemon,,,:/var/lib/colord:/usr/sbin/nologin
pulse:x:126:133:PulseAudio daemon,,,:/var/run/pulse:/usr/sbin/nologin
speech-dispatcher:x:127:29:Speech Dispatcher,,,:/run/speech-dispatcher:/bin/false
hplip:x:128:7:HPLIP system user,,,:/run/hplip:/bin/false
gnome-initial-setup:x:129:65534::/run/gnome-initial-setup/:/bin/false
gdm:x:130:135:Gnome Display Manager:/var/lib/gdm3:/bin/false
systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin
simspace:x:1000:1000:simspace:/home/simspace:/bin/bash
lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false
quagga:x:131:137:Quagga routing suite,,,:/run/quagga/:/usr/sbin/nologin
fwupd-refresh:x:132:138:fwupd-refresh user,,,:/run/systemd:/usr/sbin/nologin
badguy:x:1001:1001:Training user for Counter Strike Operations:/home/badguy:/bin/bash
svc_backup:x:1002:1002:Backup service account - VELVET-ANCHOR:/home/svc_backup:/bin/bash
app_runner:x:1003:1003:Application runner:/home/app_runner:/bin/bash

badguy@boar-11:~$ cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,simspace
tty:x:5:syslog
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:simspace
floppy:x:25:
tape:x:26:
sudo:x:27:simspace,badguy
audio:x:29:pulse
dip:x:30:simspace
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:simspace
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
systemd-journal:x:101:
systemd-network:x:102:
systemd-resolve:x:103:
systemd-timesync:x:104:
crontab:x:105:
messagebus:x:106:
input:x:107:
kvm:x:108:
render:x:109:
syslog:x:110:
tss:x:111:
uuidd:x:112:
tcpdump:x:113:
ssh:x:114:
landscape:x:115:
lxd:x:116:simspace
netdev:x:117:
ntp:x:118:
docker:x:119:
docker-registry:x:120:
lpadmin:x:121:
ssl-cert:x:122:
rtkit:x:123:
whoopsie:x:124:
geoclue:x:125:
bluetooth:x:126:
avahi-autoipd:x:127:
avahi:x:128:
scanner:x:129:saned
saned:x:130:
nm-openvpn:x:131:
colord:x:132:
pulse:x:133:
pulse-access:x:134:
gdm:x:135:
systemd-coredump:x:999:
simspace:x:1000:
quaggavty:x:136:quagga
quagga:x:137:
fwupd-refresh:x:138:
badguy:x:1001:
svc_backup:x:1002:
app_runner:x:1003:

badguy@boar-11:~$ cd ..
badguy@boar-11:/home$ ls
app_runner  badguy  lost+found  simspace  svc_backup
badguy@boar-11:/home$ cd svc_backup/
badguy@boar-11:/home/svc_backup$ ls
flag.txt
badguy@boar-11:/home/svc_backup$ cat flag.txt 
VELVET-ANCHOR

```

##  services
```
badguy@boar-11:/home$ nc -v  localhost 8081
Connection to localhost 8081 port [tcp/tproxy] succeeded!

HTTP/1.1 400 Bad Request
Date: Mon, 01 Jun 2026 17:16:43 GMT
Server: Apache/2.4.41 (Ubuntu)
X-SysWatch-Status: SIGNAL-HARBOR
Content-Length: 314
Connection: close
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>400 Bad Request</title>
</head><body>
<h1>Bad Request</h1>
<p>Your browser sent a request that this server could not understand.<br />
</p>
<hr>
<address>Apache/2.4.41 (Ubuntu) Server at syswatch-metrics.local Port 80</address>
</body></html>

```

## Logs
```
badguy@boar-11:/home$ cat /var/log/sys
syslog       syslog.1     syslog.2.gz  syslog.3.gz  syslog.4.gz  syslog.5.gz  syslog.6.gz  syslog.7.gz  syswatch/    
badguy@boar-11:/home$ cat /var/log/syswatch/app.log 
[2024-01-15 12:00:00] Backup completed by svc_backup. COBALT-TRACE

```

## Service Configurations
```
badguy@boar-11:/var/www/html$ ls
db_config.txt  index.html
badguy@boar-11:/var/www/html$ cat db_config.txt 
cat: db_config.txt: Permission denied
badguy@boar-11:/var/www/html$ sudo -i
root@boar-11:~# cd /var/www/html/
root@boar-11:/var/www/html# cat db_config.txt 
# DB connection (assessment artifact)
db_host=localhost
db_user=syswatch_app
connection_secret=QUARTZ-VEIL
```



---
# Part 2: Windows

1. NIMBUS-KEYSTONE - desktop
2. BRAVO-EMBER - schtasks
3. TIDAL-ROUTE - http header from running service
4. POLAR-CIPHER - processes
5. OPAL-MATRIX - from service config

```
c:\Users> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\Users

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
06/16/2021  10:01 PM    <DIR>          Public
05/29/2026  09:52 AM    <DIR>          svc_backup
               0 File(s)              0 bytes
               4 Dir(s)  84,354,191,360 bytes free

c:\Users> cd svc_backup


c:\Users\svc_backup>
dir
c:\Users\svc_backup> Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\Users\svc_backup

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
05/29/2026  09:52 AM    <DIR>          Desktop
               0 File(s)              0 bytes
               3 Dir(s)  84,354,191,360 bytes free

dir /a
c:\Users\svc_backup> Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\Users\svc_backup

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
05/29/2026  09:52 AM    <DIR>          Desktop
               0 File(s)              0 bytes
               3 Dir(s)  84,354,191,360 bytes free

cd Desktop
c:\Users\svc_backup>

c:\Users\svc_backup\Desktop>
dir
c:\Users\svc_backup\Desktop> Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\Users\svc_backup\Desktop

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
05/29/2026  09:52 AM                17 flag.txt
               1 File(s)             17 bytes
               2 Dir(s)  84,354,191,360 bytes free

type flag.txt
c:\Users\svc_backup\Desktop>NIMBUS-KEYSTONE

```

```
dir c:\windows\tasks

 Directory of c:\Windows\Tasks

06/16/2021  10:00 PM    <DIR>          .
06/16/2021  10:00 PM    <DIR>          ..
05/31/2026  11:40 PM               764 CS_OPS_Backup.job
               1 File(s)            764 bytes
               2 Dir(s)  84,354,183,168 bytes free

c:\Windows\Tasks> file CS*
'file' is not recognized as an internal or external command,
operable program or batch file.

c:\Windows\Tasks> type CS*

CS_OPS_Backup.job


[-] Decoding error detected, consider running chcp.com at the target,
map the result with https://docs.python.org/3/library/codecs.html#standard-encodings
and then execute smbexec.py again with -codec and the corresponding codec

��ǌCM�'��վ�YF�<

[-] Decoding error detected, consider running chcp.com at the target,
map the result with https://docs.python.org/3/library/codecs.html#standard-encodings
and then execute smbexec.py again with -codec and the corresponding codec
@s��:C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe�-NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\cs_ops\scripts\Invoke-CsOpsBackup.ps1" -ProcessFlag "BRAVO-EMBER" -TaskLogPath "C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log"C:\ProgramData\cs_ops\scriptsWORKGROUP\BULL-120��

```

```
c:\Windows\Tasks> netstat -ano

  Proto  Local Address          Foreign Address        State           PID
  TCP    0.0.0.0:80             0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       888
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:5985           0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:8022           0.0.0.0:0              LISTENING       2256
  TCP    0.0.0.0:47001          0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:49664          0.0.0.0:0              LISTENING       504
  TCP    0.0.0.0:49665          0.0.0.0:0              LISTENING       1084
  TCP    0.0.0.0:49666          0.0.0.0:0              LISTENING       1360
  TCP    0.0.0.0:49667          0.0.0.0:0              LISTENING       2144
  TCP    0.0.0.0:49668          0.0.0.0:0              LISTENING       1232
  TCP    0.0.0.0:49669          0.0.0.0:0              LISTENING       640
  TCP    0.0.0.0:49670          0.0.0.0:0              LISTENING       660
  TCP    10.10.20.12:139        0.0.0.0:0              LISTENING       4
  TCP    20.30.40.12:139        0.0.0.0:0              LISTENING       4
  TCP    20.30.40.12:445        80.90.100.10:54156     ESTABLISHED     4
  TCP    20.30.40.12:445        80.90.100.10:54168     ESTABLISHED     4
  TCP    20.30.40.12:445        80.90.100.10:54182     ESTABLISHED     4
  TCP    20.30.40.12:445        80.90.100.10:54192     ESTABLISHED     4
  TCP    [::]:80                [::]:0                 LISTENING       4
  TCP    [::]:135               [::]:0                 LISTENING       888
  TCP    [::]:445               [::]:0                 LISTENING       4
  TCP    [::]:5985              [::]:0                 LISTENING       4
  TCP    [::]:8022              [::]:0                 LISTENING       2256
  TCP    [::]:47001             [::]:0                 LISTENING       4
  TCP    [::]:49664             [::]:0                 LISTENING       504
  TCP    [::]:49665             [::]:0                 LISTENING       1084
  TCP    [::]:49666             [::]:0                 LISTENING       1360
  TCP    [::]:49667             [::]:0                 LISTENING       2144
  TCP    [::]:49668             [::]:0                 LISTENING       1232
  TCP    [::]:49669             [::]:0                 LISTENING       640
  TCP    [::]:49670             [::]:0                 LISTENING       660
  UDP    0.0.0.0:123            *:*                                    2396
  UDP    0.0.0.0:500            *:*                                    908
  UDP    0.0.0.0:4500           *:*                                    908
  UDP    0.0.0.0:5353           *:*                                    1436
  UDP    0.0.0.0:5355           *:*                                    1436
  UDP    10.10.20.12:137        *:*                                    4
  UDP    10.10.20.12:138        *:*                                    4
  UDP    20.30.40.12:137        *:*                                    4
  UDP    20.30.40.12:138        *:*                                    4
  UDP    [::]:123               *:*                                    2396
  UDP    [::]:500               *:*                                    908
  UDP    [::]:4500              *:*                                    908
  UDP    [::]:5353              *:*                                    1436
  UDP    [::]:5355              *:*                                    1436

c:\Windows\Tasks> dir
 Volume in drive C has no label.

 Volume Serial Number is F054-2324
 Directory of c:\Windows\Tasks

06/16/2021  10:00 PM    <DIR>          .
06/16/2021  10:00 PM    <DIR>          ..
05/31/2026  11:40 PM               764 CS_OPS_Backup.job

               1 File(s)            764 bytes

               2 Dir(s)  84,354,183,168 bytes free


c:\Windows\Tasks> curl http://localhost

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to localhost (::1) port 80 (#0)

> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/7.55.1
> Accept: */*

< HTTP/1.1 200 OK
< Content-Type: text/html
< Last-Modified: Fri, 29 May 2026 13:54:04 GMT
< Accept-Ranges: bytes
< ETag: "508c419c72efdc1:0"
< Server: Microsoft-IIS/10.0
< X-Backend-Service: TIDAL-ROUTE
< Date: Mon, 01 Jun 2026 18:03:22 GMT
< Content-Length: 187
< { [187 bytes data]
100   187  100   187    0     0    187      0  0:00:01 --:--:--  0:00:01   291
* Connection #0 to host localhost left intact

<!DOCTYPE html>
<html>
<head><title>Backend Service</title></head>
<body>
<h1>Backend Service</h1>
<p>Service status indicators are exposed in HTTP response metadata.</p>
</body>
</html>

```

```
c:\> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\

05/29/2026  09:53 AM    <DIR>          inetpub
05/08/2021  04:17 AM    <DIR>          PerfLogs
01/31/2023  04:48 PM    <DIR>          Program Files
06/16/2021  05:13 PM    <DIR>          Program Files (x86)
01/31/2023  02:07 PM        40,476,822 SystemInit-puppet7.exe
05/29/2026  09:52 AM    <DIR>          temp
05/29/2026  09:52 AM    <DIR>          Users
06/01/2026  01:47 PM    <DIR>          Windows
               1 File(s)     40,476,822 bytes
               7 Dir(s)  84,353,433,600 bytes free

c:\> cd temp

c:\temp> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\temp

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
               0 File(s)              0 bytes
               2 Dir(s)  84,353,433,600 bytes free

c:\temp> dir /a
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\temp

05/29/2026  09:52 AM    <DIR>          .
05/29/2026  09:52 AM    <DIR>          ..
               0 File(s)              0 bytes
               2 Dir(s)  84,353,433,600 bytes free

c:\temp> cd ..

c:\> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\

05/29/2026  09:53 AM    <DIR>          inetpub
05/08/2021  04:17 AM    <DIR>          PerfLogs
01/31/2023  04:48 PM    <DIR>          Program Files
06/16/2021  05:13 PM    <DIR>          Program Files (x86)
01/31/2023  02:07 PM        40,476,822 SystemInit-puppet7.exe
05/29/2026  09:52 AM    <DIR>          temp
05/29/2026  09:52 AM    <DIR>          Users
06/01/2026  01:47 PM    <DIR>          Windows
               1 File(s)     40,476,822 bytes
               7 Dir(s)  84,353,433,600 bytes free

c:\> cd inet*

c:\inetpub> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\inetpub

05/29/2026  09:53 AM    <DIR>          .
05/29/2026  09:53 AM    <DIR>          ..
05/29/2026  09:53 AM    <DIR>          custerr
05/29/2026  09:53 AM    <DIR>          history
05/29/2026  09:53 AM    <DIR>          logs
05/29/2026  09:53 AM    <DIR>          temp
05/29/2026  09:54 AM    <DIR>          wwwroot
               0 File(s)              0 bytes
               7 Dir(s)  84,353,433,600 bytes free

c:\inetpub> cd www*

c:\inetpub\wwwroot> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\inetpub\wwwroot

05/29/2026  09:54 AM    <DIR>          .
05/29/2026  09:54 AM    <DIR>          ..
05/29/2026  09:54 AM               109 db_config.txt
05/29/2026  09:53 AM               703 iisstart.htm
05/29/2026  09:53 AM            99,710 iisstart.png
05/29/2026  09:54 AM               187 index.html
               4 File(s)        100,709 bytes
               2 Dir(s)  84,353,433,600 bytes free

c:\inetpub\wwwroot> type db*

db_config.txt


# DB connection (assessment artifact)
db_host=localhost
db_user=cs_ops_app
connection_secret=OPAL-MATRIX
```

```
wmic process get name,executablepath,commandline /format:list | more

CommandLine="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\ProgramData\cs_ops\scripts\Invoke-CsOpsAppLogWriter.ps1 -AppLogPath C:\ProgramData\cs_ops\logs\app.log 
ExecutablePath=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
Name=powershell.exe
ProcessId=1216

c:\inetpub\wwwroot> type c:\programdata\cs_ops\logs\app.log
[2024-01-15 12:00:00] Backup completed by svc_backup. POLAR-CIPHER
[2026-06-01 14:12:00] app-log writer heartbeat.
[2026-06-01 14:12:05] app-log writer heartbeat.
[2026-06-01 14:13:30] app-log writer heartbeat.
[2026-06-01 14:13:35] app-log writer heartbeat.
[2026-06-01 14:15:00] app-log writer heartbeat.
[2026-06-01 14:15:05] app-log writer heartbeat.
[2026-06-01 14:16:30] app-log writer heartbeat.
[2026-06-01 14:16:35] app-log writer heartbeat.
[2026-06-01 14:18:00] app-log writer heartbeat.
[2026-06-01 14:18:05] app-log writer heartbeat.
[2026-06-01 14:19:30] app-log writer heartbeat.
[2026-06-01 14:19:35] app-log writer heartbeat.
[2026-06-01 14:21:00] app-log writer heartbeat.
[2026-06-01 14:21:05] app-log writer heartbeat.
[2026-06-01 14:22:30] app-log writer heartbeat.
[2026-06-01 14:22:35] app-log writer heartbeat.
[2026-06-01 14:24:01] app-log writer heartbeat.
[2026-06-01 14:24:05] app-log writer heartbeat.
[2026-06-01 14:25:31] app-log writer heartbeat.
[2026-06-01 14:25:35] app-log writer heartbeat.
[2026-06-01 14:27:01] app-log writer heartbeat.
[2026-06-01 14:27:05] app-log writer heartbeat.

```

```
c:\> dir
 Volume in drive C has no label.

Volume Serial Number is F054-2324

 Directory of c:\

05/29/2026  09:53 AM    <DIR>          inetpub
05/08/2021  04:17 AM    <DIR>          PerfLogs
01/31/2023  04:48 PM    <DIR>          Program Files
06/16/2021  05:13 PM    <DIR>          Program Files (x86)
01/31/2023  02:07 PM        40,476,822 SystemInit-puppet7.exe
05/29/2026  09:52 AM    <DIR>          temp
05/29/2026  09:52 AM    <DIR>          Users
06/01/2026  01:47 PM    <DIR>          Windows
               1 File(s)     40,476,822 bytes
               7 Dir(s)  84,353,433,600 bytes free

c:\> cd inet

c:\inetpub> dir
 Volume in drive C has no label.

 Volume Serial Number is F054-2324

 Directory of c:\inetpub

05/29/2026  09:53 AM    <DIR>          .
05/29/2026  09:53 AM    <DIR>          ..
05/29/2026  09:53 AM    <DIR>          custerr
05/29/2026  09:53 AM    <DIR>          history
05/29/2026  09:53 AM    <DIR>          logs
05/29/2026  09:53 AM    <DIR>          temp
05/29/2026  09:54 AM    <DIR>          wwwroot
               0 File(s)              0 bytes
               7 Dir(s)  84,353,433,600 bytes free

c:\inetpub> cd www*

c:\inetpub\wwwroot> dir
 Volume in drive C has no label.
 Volume Serial Number is F054-2324

 Directory of c:\inetpub\wwwroot

05/29/2026  09:54 AM    <DIR>          .
05/29/2026  09:54 AM    <DIR>          ..
05/29/2026  09:54 AM               109 db_config.txt
05/29/2026  09:53 AM               703 iisstart.htm
05/29/2026  09:53 AM            99,710 iisstart.png
05/29/2026  09:54 AM               187 index.html
               4 File(s)        100,709 bytes
               2 Dir(s)  84,353,433,600 bytes free

c:\inetpub\wwwroot> type db*

db_config.txt

# DB connection (assessment artifact)
db_host=localhost
db_user=cs_ops_app
connection_secret=OPAL-MATRIX

```