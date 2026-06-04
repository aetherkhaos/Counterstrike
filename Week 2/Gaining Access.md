## Continue to apply the correct mindset, "We are not Pentesters".

## T1190 - Exploit Public Facing Application


primitive - a basic building-block (EX: read, write, execute)

**Step-by-Step Exploitation Process:**
-  **Identify Vulnerability**: Match recon (e.g., nginx 1.18) to CVE via NVD
- **Select/Prepare Exploit**: Download/adapt from ExploitDB or Metasploit (e.g., modify PoC for target version)
- **Execute Exploit**: Run against adversary IP address (e.g., msfconsole > use exploit/multi/http/nginx_chunked_size > set RHOSTS)
- **Obtain Shell/Access**: Establish reverse shell or Meterpreter session for post-exploitation effects

## T1133 - External Remote Services

T1133 Definition: Gaining access via vulnerabilities in exposed remote access protocols on adversary infrastructure (e.g., VPN gateways, RDP desktops, SSH servers)

Common Targets: VPN (IPsec/IKE vulns), RDP (port 3389), SSH (port 22).

Counterstrike Role: Compromise remote entry points to reach internal adversary networks for broader disruption.

Access Methods for T1133
	- Methods: Vulnerability Exploitation
		- Vulnerability Exploitation: CVEs in software (e.g., CVE-2019-11510 in Pulse Secure VPN for RCE; BlueKeep in RDP for code execution).
		- Process: Identify version from recon, select exploit (e.g., Metasploit module for SSH regreSSHion CVE-2024-6387), execute for shell.
	- Examples of RDP Brute Force, SSH with Discovered Keys, VPN Exploit:
		- RDP Exploit: Metasploit for BlueKeep CVE-2019-0708 (e.g., use exploit/windows/rdp/cve_2019_0708_bluekeep_rce > execute for shell on Windows C2 host).
		- SSH Exploit: Use CVE-2024-6387 regreSSHion (e.g., custom PoC for RCE on vulnerable OpenSSH).
		- VPN Exploit: Metasploit for CVE-2019-11510 (e.g., use exploit/linux/http/pulse_secure_rce > execute for shell).
		- Operational: Gain persistent access to adversary operations consoles for effects like data denial.

T1078 Valid Accounts

Sourcing and Using Credentials

Primary: Unique defender intel like hardcoded credentials in malware (e.g., discovered via analysis of captured samples in blue space hunts) or IOCs from network traffic (e.g., creds in adversary malware beacons or exfiltration attempts).

Secondary Techniques: OSINT/breach data; password spraying (common pwds across users); credential stuffing (reused pwds).

Examples of SSH with Breached Credentials, RDP with Weak Password

SSH: Use hardcoded creds from malware analysis (e.g., ssh admin@target with password extracted from captured C2 binary during blue space hunts).

RDP: Stuffing tool like Crowbar with weak/default password from IOCs (e.g., against Windows C2 host for desktop access).

Outcome: Full session for disruption (e.g., delete configs); low noise if creds valid.

T1534 Internal Spear Phishing

T1534 in Operations
Execution: Craft lures mimicking high-value intel (e.g., fake military docs with exploit code or tracking pixels) placed in monitored blue space areas (e.g., email traps, shared drives) likely to be targeted by adversary theft.

Value: When adversary collects/exfils lure, trigger activates (e.g., beacon or reverse exploit) for initial access to their red infrastructure, leveraging their expected behavior from prior hunts.

Operational Note: Monitor blue space for collection triggers; high OPSEC as no direct contact with adversary until they engage; transition access to CMT if lateral required.

Forward Look at CMT Handover: 

T1534 secures initial foothold via reverse access (e.g., from lure trigger to adversary analysis node or C2.

Combine with other vectors for robust initial access; hand off to CMT for lateral movement or expansion.

