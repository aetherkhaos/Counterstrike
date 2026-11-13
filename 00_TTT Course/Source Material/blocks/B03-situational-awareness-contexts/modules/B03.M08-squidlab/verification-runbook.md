---
id: B03.M08-verify
title: SquidLab — Verification
artifact_type: verification_runbook
audience: builder
block: B03
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: verification_runbook_v1
sensitivity: instructor_only
environments:
- b03_squidlab
- week3-constrained
- classroom-shared
---

# SquidLab — Verification

Do not duplicate the full bake in [`setup-guide.md`](./setup-guide.md). These checks confirm the guests are ready for class. Lab LAN is `172.16.173.0/24`.

## Preflight

- Bake scripts present in [`environments/b03_squidlab/`](../../../../environments/b03_squidlab/)
- C2, pfSense redirector, and optional Win-Svr02 powered on
- Student access is `week3-constrained`. Windows seat `victim` at lab address `80.90.100.11/24` can reach the shared lab LAN. `10.10.80.11/16` is the PCTE management NIC only.
- Shared instructor access to the classwide guests is `classroom-shared`.
- Alpine WSL image on that seat (`wsl -d Alpine`)

## Post-deploy checks

From a seat that can reach `172.16.173.0/24`:

1. `wsl -d Alpine` — clean prompt; `ps` shows `/root/.bash`.
2. `nmap -Pn -sV -p 22,80,443 172.16.173.100` — pfSense services.
3. `https://172.16.173.100` — `admin` / `pfsense`. Confirm NAT 80 and OpenVPN up.
4. `scp admin@172.16.173.100:/root/.tmp/redir-cert.ovpn .`
5. `sudo openvpn --config redir-cert.ovpn` — `tun0` in `192.168.135.0/24`. WSL often has no `/dev/net/tun`; use Windows OpenVPN or a full Linux NIC.
6. `curl http://192.168.135.1:8000/` — operator cfg and ovpn files.
7. If stolen cfg `lhost` is still `172.16.173.101`, change it to `192.168.135.1`.
8. `sliver-client import` of the modified operator cfg — Alpine beacon, and Octagon-SECDEF if Win-Svr02 is live.
9. `c2-env-check.sh` on C2 is all PASS.
10. C2 iptables allows the redirector, the OpenVPN net, and builder SSH. If students can hit `:8000` or Sliver **without** the VPN, isolation is wrong — fix before class.

## Student-path smoke

Students start from the recovered Alpine WSL distro on the ops-station Windows seat. They must be able to:

- Enumerate the image and find the implant without a pre-briefed path
- Reach the redirector on the lab LAN
- Follow evidence to the tunnel and C2 **over OpenVPN**

Do not pre-brief C2 or the VPN net. Range clue, if issued, is the redirector only.

## Reset / clean-start confirmation

- Alpine beacon is running and calling the redirector on HTTP/80
- pfSense OpenVPN client is up (`tun0`)
- C2 Sliver listener and staging server are up
- Win-Svr02 session (if used) is live and **not** killed
- After class, redeploy the PCTE range or the specific VM from the same clone
