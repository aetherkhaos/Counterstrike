# Part 1: The Chroot Jail
## Flags
1. SHADOW-LOCKET
2. FRACTAL-LENS
3. ORBIT-CIRCUIT
4. KESTREL-THREAD

## Access
```
┌──(kali㉿kali)-[~]
└─$ nc 20.30.40.21 4444
/bin/sh: 0: can't access tty; job control turned off
#
```

### or, throught msf
```

```

## Systeminfo
```
# whoami
root
# uname -a
Linux collie-21 5.4.0-135-generic #152-Ubuntu SMP Wed Nov 23 20:19:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
# echo $SHELL

# man init | head
/bin/sh: 4: man: not found
```

## Shell upgrade
```
# python3
/bin/sh: 1: python3: not found
# python
/bin/sh: 2: python: not found
```

## Read /usr/share/doc/base-files/runtime-notes and follow the chain until you find the flag.
```
# ls -la
total 20
drwxr-xr-x 3 root root 4096 May 29 16:56 .
drwxr-xr-x 3 root root 4096 Mar 19 13:23 ..
-rw-r--r-- 1 root root  704 May 29 16:56 README.first
-rw-r--r-- 1 root root   14 May 29 16:56 cache.id
drwxr-xr-x 2 root root 4096 May 29 16:56 notes

# ls -la notes
total 12
drwxr-xr-x 2 root root 4096 May 29 16:56 .
drwxr-xr-x 3 root root 4096 May 29 16:56 ..
-rw-r--r-- 1 root root  385 May 29 16:56 fragments.txt

# cat README.first
/bin/sh: 4: cat: not found

# head README.first
Start by mapping this filesystem and recording what tools are missing.
This README is the instruction surface for the flags in this jail.
For one flag, read /usr/share/doc/base-files/runtime-notes and follow the chain until you find the flag.
For one flag, reconstruct the value from references in /opt/lab21/notes/fragments.txt.
For one flag, query the loopback-only TCP service at 127.0.0.1:4545 and send exactly 1234 followed by a newline.
For one flag, review parent process environment evidence at /proc/$PPID/environ, identify the session token assignment, and send only that token value plus a newline to 127.0.0.1:4646.
Use fundamental commands and inspect files before executing custom helpers.

# head /usr/share/doc/base-files/runtime-notes
Runtime package note
The maintenance cache map is stored at /var/lib/dpkg/info/.cache.map.
Strip NUL bytes from it to reveal NEXT_HINT.

# head /var/lib/dpkg/info/.cache.map
NEXT_HINT=/var/log/apt/term.log.1.gz

# gunzip /var/log/apt/term.log.1.gz

# head /var/log/apt/term.log.1
Cache recovery usage
The decoder command is on PATH as restore-cache.
Example: restore-cache cache.id

# which restore-cache
/usr/local/bin/restore-cache

# file /usr/local/bin/restore-cache
/bin/sh: 9: file: not found

# head -1 /usr/local/bin/restore-cache
#!/bin/sh

# head /usr/local/bin/restore-cache
#!/bin/sh
if [ "$#" -ne 1 ]; then
  printf "%s\n" "usage: restore-cache <file-name>"
  exit 1
fi
input_file="${1##*/}"
if [ ! -r "$input_file" ]; then
  printf "%s\n" "cannot read input file: $input_file"
  exit 1
fi

# ls -la
total 20
drwxr-xr-x 3 root root 4096 May 29 16:56 .
drwxr-xr-x 3 root root 4096 Mar 19 13:23 ..
-rw-r--r-- 1 root root  704 May 29 16:56 README.first
-rw-r--r-- 1 root root   14 May 29 16:56 cache.id
drwxr-xr-x 2 root root 4096 May 29 16:56 notes

# restore-cache cache.id
SHADOW-LOCKET
```

## Reconstruct the value from references in /opt/lab21/notes/fragments.txt
```
# head -20 /opt/lab21/notes/fragments.txt
challenge=resolve_fragment_references
format=slot_NN|state=keep|value=<file-path>
slot_03|state=keep|value=/var/lib/dpkg/info/base-files.list.d
slot_90|state=drop|value=/var/tmp/.font-unix-cache
slot_01|state=keep|value=/etc/apt/preferences.d/00-cache-state
slot_91|state=drop|value=/usr/share/common-licenses/.runtime-index
slot_02|state=keep|value=/usr/share/doc/bash/inputrc.sample

# head /var/lib/dpkg/info/base-files.list.d
fragment=-LENS
# head /var/tmp/.font-unix-cache
fragment=DECOY-
# head /etc/apt/preferences.d/00-cache-state
fragment=FRA
# head /usr/share/common-licenses/.runtime-index
fragment=IGNORE
# head /usr/share/doc/bash/inputrc.sample
fragment=CTAL

FRACTAL-LENS

```

## Query the loopback-only TCP service at 127.0.0.1:4545 and send exactly 1234 followed by a newline.
```
# ls /bin
[
addpart
apt
apt-cache
apt-cdrom
apt-config
apt-get
apt-key
apt-mark
arch
awk
b2sum
base32
base64
basename
bash
bashbug
captoinfo
catchsegv
chage
chattr
chcon
chfn
chgrp
chmod
choom
chown
chrt
chsh
cksum
clear
clear_console
cmp
comm
cp
csplit
curl
cut
dash
date
dd
deb-systemd-helper
deb-systemd-invoke
debconf
debconf-apt-progress
debconf-communicate
debconf-copydb
debconf-escape
debconf-set-selections
debconf-show
delpart
df
diff
diff3
dir
dircolors
dirname
dmesg
dnsdomainname
domainname
dpkg
dpkg-deb
dpkg-divert
dpkg-maintscript-helper
dpkg-query
dpkg-split
dpkg-statoverride
dpkg-trigger
du
echo
egrep
env
expand
expiry
expr
factor
faillog
fallocate
false
fgrep
fincore
findmnt
flock
fmt
fold
free
getconf
getent
getopt
gpasswd
gpgv
groups
gunzip
gzexe
gzip
head
hostid
hostname
i386
iconv
id
infocmp
infotocap
install
ionice
ipcmk
ipcrm
ipcs
ischroot
join
kill
last
lastb
lastlog
ldd
link
linux32
linux64
ln
locale
locale-check
localedef
logger
login
logname
ls
lsattr
lsblk
lscpu
lsipc
lslocks
lslogins
lsmem
lsns
mawk
mcookie
md5sum
md5sum.textutils
mesg
mkdir
mkfifo
mknod
mktemp
more
mount
mountpoint
mv
namei
nawk
newgrp
nice
nisdomainname
nl
nohup
nproc
nsenter
numfmt
od
pager
partx
passwd
paste
pathchk
perl
perl5.30.0
pgrep
pidof
pinky
pkill
pldd
pmap
pr
printenv
printf
prlimit
ps
ptx
pwd
pwdx
rbash
rcp
readlink
realpath
rename.ul
renice
reset
resizepart
rev
rgrep
rlogin
rm
rmdir
rsh
run-parts
runcon
savelog
scp
script
scriptreplay
sdiff
sed
select-editor
sensible-browser
sensible-editor
sensible-pager
seq
setarch
setpriv
setsid
setterm
sftp
sg
sh
sha1sum
sha224sum
sha256sum
sha384sum
sha512sum
shred
shuf
skill
slabtop
sleep
slogin
snice
sort
split
ssh
ssh-add
ssh-agent
ssh-argv0
ssh-copy-id
ssh-keygen
ssh-keyscan
stat
stdbuf
stty
su
sum
sync
tabs
tac
tail
tar
taskset
tee
tempfile
test
tic
timeout
tload
toe
top
touch
tput
tr
true
truncate
tset
tsort
tty
tzselect
umount
uname
uncompress
unexpand
uniq
unlink
unshare
update-alternatives
uptime
users
utmpdump
vdir
vmstat
w
w.procps
wall
watch
wc
wdctl
whereis
which
who
whoami
x86_64
xargs
yes
ypdomainname
zcat
zcmp
zdiff
zdump
zegrep
zfgrep
zforce
zgrep
zless
zmore
znew

## Feed into the local AI and give it the problem

# perl -MIO::Socket::INET -e '$s=IO::Socket::INET->new("127.0.0.1:4545"); print $s "1234\n"; print <$s>;'
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
ORBIT-CIRCUIT
```
### Or, instead of PEARL...
```
# echo "1234" | curl telnet://127.0.0.1:4545
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    19    0    14    0     5    138     49 --:--:-- --:--:-- --:--:--   190
ORBIT-CIRCUIT
```

## Review parent process environment evidence at /proc/$PPID/environ, identify the session token assignment, and send only that token value plus a newline to 127.0.0.1:4646.
```
# echo $PPID
69205

# ls -la /proc/69205/environ
-r-------- 1 root root 0 Jun  2 13:41 /proc/69205/environ

# head /proc/69205/environ
LANG=en_US.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binINVOCATION_ID=8bbe2297c24447b4a15f285e0429f543JOURNAL_STREAM=9:32395LAB21_SESSION_TOKEN=toortoor

# perl -MIO::Socket::INET -e '$s=IO::Socket::INET->new("127.0.0.1:4646"); print $s "toortoor\n"; print <$s>;'
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
KESTREL-THREAD
```
### Or, instead of PEARL...
```
# echo "toortoor" | curl telnet://127.0.0.1:4646
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    24    0    15    0     9    145     87 --:--:-- --:--:-- --:--:--   233
KESTREL-THREAD
```



---
# Part 2: Living with AppArmor Restrictions
## Flags:
1. AEGIS-MARK
2. x
3. x
4. x

## Connecting to target
```
┌──(kali㉿kali)-[~]
└─$ ssh badguy@20.30.40.22 
The authenticity of host '20.30.40.22 (20.30.40.22)' can't be established.
ED25519 key fingerprint is: SHA256:5urkJTfIERXGIaVupbdtXNC2RP+33AbYdGcCtamb0Ak
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:6: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.30.40.22' (ED25519) to the list of known hosts.
** WARNING: connection is not using a post-quantum key exchange algorithm.
** This session may be vulnerable to "store now, decrypt later" attacks.
** The server may need to be upgraded. See https://openssh.com/pq.html
badguy@20.30.40.22's password: 
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)

-<BREAK>-

  System load:    2.24              Users logged in:          0
  Usage of /home: 0.0% of 24.44GB   IPv4 address for docker0: 172.17.0.1
  Memory usage:   24%               IPv4 address for eth0:    10.10.20.22
  Swap usage:     7%                IPv4 address for eth1:    20.30.40.22
  Processes:      246
  
-<BREAK>-


badguy@cow-22:~$ 

```

# Systeminfo
```
badguy@cow-22:~$ uname -a
Linux cow-22 5.4.0-135-generic #152-Ubuntu SMP Wed Nov 23 20:19:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux


```

# User/Env Context
```
badguy@cow-22:~$ sudo -l
[sudo] password for badguy: 
Matching Defaults entries for badguy on cow-22:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin\:/opt/puppetlabs/bin

User badguy may run the following commands on cow-22:
    (ALL : ALL) ALL

badguy@cow-22:~$ env
SHELL=/bin/bash
PWD=/home/badguy
LOGNAME=badguy
XDG_SESSION_TYPE=tty
MANPATH=:/opt/puppetlabs/puppet/share/man
MOTD_SHOWN=pam
HOME=/home/badguy
LANG=en_US.UTF-8
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:
SSH_CONNECTION=80.90.100.10 43426 20.30.40.22 22
LESSCLOSE=/usr/bin/lesspipe %s %s
XDG_SESSION_CLASS=user
TERM=xterm-256color
LESSOPEN=| /usr/bin/lesspipe %s
USER=badguy
SHLVL=1
XDG_SESSION_ID=69
XDG_RUNTIME_DIR=/run/user/1001
SSH_CLIENT=80.90.100.10 43426 22
XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/puppetlabs/bin
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus
SSH_TTY=/dev/pts/0
_=/usr/bin/env


badguy@cow-22:~$ man init | head
SYSTEMD(1)                                            systemd                                           SYSTEMD(1)

NAME
       systemd, init - systemd system and service manager

badguy@cow-22:~$ pwd
/home/badguy

badguy@cow-22:~$ ls -la
total 36
drwxr-xr-x 5 badguy badguy 4096 Jun  2 12:28 .
drwxr-xr-x 6 root   root   4096 May 29 12:56 ..
-rw------- 1 badguy badguy    5 Jun  2 10:19 .bash_history
-rw-r--r-- 1 badguy badguy  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 badguy badguy 3771 Feb 25  2020 .bashrc
drwxr-xr-x 4 badguy badguy 4096 Jun  2 10:15 .cache
drwx------ 4 badguy badguy 4096 Jun  2 10:15 .config
drwxr-xr-x 3 badguy badguy 4096 Jun  2 10:15 .local
-rw-r--r-- 1 badguy badguy  807 Feb 25  2020 .profile
-rw-r--r-- 1 badguy badguy    0 Jun  2 12:28 .sudo_as_admin_successful

badguy@cow-22:~$ ls -la ..
total 36
drwxr-xr-x  6 root     root      4096 May 29 12:56 .
drwxr-xr-x 20 root     root      4096 Apr 22  2021 ..
drwxr-xr-x  5 badguy   badguy    4096 Jun  2 12:28 badguy
drwxr-xr-x  3 root     root      4096 May 29 12:56 hunter
drwx------  2 root     root     16384 Apr 22  2021 lost+found
drwxr-xr-x 16 simspace simspace  4096 Jan  5  2023 simspace

badguy@cow-22:~$ ls -la ../hunter
total 12
drwxr-xr-x 3 root   root   4096 May 29 12:56 .
drwxr-xr-x 6 root   root   4096 May 29 12:56 ..
drwxr-xr-x 2 hunter hunter 4096 May 29 12:56 downloads

badguy@cow-22:~$ ls -la ../hunter/downloads
total 8
drwxr-xr-x 2 hunter hunter 4096 May 29 12:56 .
drwxr-xr-x 3 root   root   4096 May 29 12:56 ..
```

# Confirm AppArmor status and identify relevant profile state and policy locations.
```
adguy@cow-22:~$ sudo apparmor_status 
apparmor module is loaded.
44 profiles are loaded.
43 profiles are in enforce mode.
   /snap/snapd/17883/usr/lib/snapd/snap-confine
   /snap/snapd/17883/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/evince
   /usr/bin/evince-previewer
   /usr/bin/evince-previewer//sanitized_helper
   /usr/bin/evince-thumbnailer
   /usr/bin/evince//sanitized_helper
   /usr/bin/man
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/cups/backend/cups-pdf
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/local/bin/objective-gate-check
   /usr/local/sbin/runtime-cache-worker
   /usr/sbin/cups-browsed
   /usr/sbin/cupsd
   /usr/sbin/cupsd//third_party
   /usr/sbin/ntpd
   /usr/sbin/tcpdump
   /{,usr/}sbin/dhclient
   docker-default
   ippusbxd
   lsb_release
   man_filter
   man_groff
   nvidia_modprobe
   nvidia_modprobe//kmod
   snap-update-ns.lxd
   snap.lxd.activate
   snap.lxd.benchmark
   snap.lxd.buginfo
   snap.lxd.check-kernel
   snap.lxd.daemon
   snap.lxd.hook.configure
   snap.lxd.hook.install
   snap.lxd.hook.remove
   snap.lxd.lxc
   snap.lxd.lxc-to-lxd
   snap.lxd.lxd
   snap.lxd.migrate
   snap.lxd.user-daemon
1 profiles are in complain mode.
   /usr/local/bin/system-maint-check
4 processes have profiles defined.
4 processes are in enforce mode.
   /usr/bin/bash (1009) /usr/local/sbin/runtime-cache-worker
   /usr/sbin/cups-browsed (3928778) 
   /usr/sbin/cupsd (3928777) 
   /usr/sbin/ntpd (1063) 
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.

badguy@cow-22:~$ ls -la /etc/apparmor.d/
total 156
drwxr-xr-x   8 root root  4096 May 29 12:56 .
drwxr-xr-x 146 root root 12288 May 29 12:56 ..
drwxr-xr-x   2 root root  4096 May 29 12:56 abi
drwxr-xr-x   4 root root 12288 May 29 12:56 abstractions
drwxr-xr-x   2 root root  4096 Apr 22  2021 disable
drwxr-xr-x   2 root root  4096 Feb 11  2020 force-complain
drwxr-xr-x   2 root root  4096 May 29 12:56 local
-rw-r--r--   1 root root  1313 Apr 12  2020 lsb_release
-rw-r--r--   1 root root  1108 Apr 12  2020 nvidia_modprobe
-rw-r--r--   1 root root  3461 Jun 21  2022 sbin.dhclient
drwxr-xr-x   5 root root  4096 May 29 12:56 tunables
-rw-r--r--   1 root root 11082 Jul  7  2020 usr.bin.evince
-rw-r--r--   1 root root  9793 Nov 29  2022 usr.bin.firefox
-rw-r--r--   1 root root  3202 Feb 25  2020 usr.bin.man
-rw-r--r--   1 root root 28486 Nov 27  2022 usr.lib.snapd.snap-confine.real
-rw-r--r--   1 root root   362 May 29 12:56 usr.local.bin.objective-gate-check
-rw-r--r--   1 root root   188 May 29 12:56 usr.local.bin.system-maint-check
-rw-r--r--   1 root root   174 May 29 12:56 usr.local.sbin.runtime-cache-worker
-rw-r--r--   1 root root   540 Apr 10  2020 usr.sbin.cups-browsed
-rw-r--r--   1 root root  5797 Apr 24  2020 usr.sbin.cupsd
-rw-r--r--   1 root root   672 Feb 19  2020 usr.sbin.ippusbxd
-rw-r--r--   1 root root  2425 Nov 27  2020 usr.sbin.ntpd
-rw-r--r--   1 root root  1575 Feb 11  2020 usr.sbin.rsyslogd
-rw-r--r--   1 root root  1385 Dec  7  2019 usr.sbin.tcpdump

badguy@cow-22:~$ ls -la /etc/apparmor.d/local/
total 16
drwxr-xr-x 2 root root 4096 May 29 12:56 .
drwxr-xr-x 8 root root 4096 May 29 12:56 ..
-rw-r--r-- 1 root root    0 Apr 23  2020 lsb_release
-rw-r--r-- 1 root root    0 Apr 23  2020 nvidia_modprobe
-rw-r--r-- 1 root root 1111 Apr 12  2020 README
-rw-r--r-- 1 root root    0 Apr 23  2020 sbin.dhclient
-rw-r--r-- 1 root root    0 Apr 22  2021 usr.bin.evince
-rw-r--r-- 1 root root  122 Apr 22  2021 usr.bin.firefox
-rw-r--r-- 1 root root    0 Apr 23  2020 usr.bin.man
-rw-r--r-- 1 root root    0 Apr 23  2020 usr.lib.snapd.snap-confine.real
-rw-r--r-- 1 root root    0 Apr 22  2021 usr.sbin.cups-browsed
-rw-r--r-- 1 root root    0 Apr 22  2021 usr.sbin.cupsd
-rw-r--r-- 1 root root    0 Apr 22  2021 usr.sbin.ippusbxd
-rw-r--r-- 1 root root    0 Apr 22  2021 usr.sbin.ntpd
-rw-r--r-- 1 root root    0 Apr 23  2020 usr.sbin.rsyslogd
-rw-r--r-- 1 root root    0 Apr 23  2020 usr.sbin.tcpdump

badguy@cow-22:~$ cat /etc/apparmor.d/usr.local.bin.system-maint-check 
#include <tunables/global>
/usr/local/bin/system-maint-check flags=(complain) {
  #include <abstractions/base>
  /usr/local/bin/system-maint-check r,
  /bin/bash ix,
  /usr/bin/bash ix,
}

badguy@cow-22:~$ system-maint-check 
AppArmor profile located. Validate with aa-status.
mac_id_flag=AEGIS-MARK


badguy@cow-22:~$ cat /usr/local/bin/system-maint-check
#!/bin/bash
# Lab 2.2 status probe
echo 'AppArmor profile located. Validate with aa-status.'
echo "mac_id_flag=$(printf '%s' 'QUVHSVMtTUFSSw==' | /usr/bin/base64 -d)"

badguy@cow-22:~$ printf '%s' 'QUVHSVMtTUFSSw==' | /usr/bin/base64 -d
AEGIS-MARK
```
# Identify and exercise lab-related helper/gate scripts in normal administrative paths.
```

```
# Execute an uploaded payload through the gate from its initial location and capture blocked/denied behavior.
```

```
# Collect denial and policy evidence from native host artifacts and correlate it to the blocked action.
```

```
# Identify an allowed execution path from policy evidence, run the same payload from that path, and validate successful behavior.
```

```