# Part 1: Linux
## Flags
1. SHADOW-LOCKET
2. FRACTAL-LENS
3. x
4. x

## Access
```
┌──(kali㉿kali)-[~]
└─$ nc 20.30.40.21 4444
/bin/sh: 0: can't access tty; job control turned off

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
# cat README.first
/bin/sh: 4: cat: not found
# head

^C
                                                                                
┌──(kali㉿kali)-[~]
└─$ nc 20.30.40.21 4444
/bin/sh: 0: can't access tty; job control turned off
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