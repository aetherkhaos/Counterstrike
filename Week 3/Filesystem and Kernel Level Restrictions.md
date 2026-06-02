# Part 1: Linux
## Flags
1. x
2. x
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

## Shell upgrade - Come back to it
```
# python3
/bin/sh: 1: python3: not found
# python
/bin/sh: 2: python: not found
```

## Establish runtime context (identity, working path, process visibility, and filesystem boundaries) from the constrained shell.
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

# head /var/log/apt/term.log.1
Cache recovery usage
The decoder command is on PATH as restore-cache.
Example: restore-cache cache.id
 
```