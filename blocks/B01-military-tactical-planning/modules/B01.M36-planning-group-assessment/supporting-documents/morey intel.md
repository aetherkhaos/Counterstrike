# Morey Intel

## it-wks-01

- Scheduled Task named: ```\Windows Module Analysis Cache``` that runs ```Invoke-WuModule.ps1```
- Deobfuscating ```Invoke-WuModule.ps1``` leads to the discovery of an ssh key: ```c:\programdata\microsoft\windows\caches\store\id_ed_25519``` and you can ssh onto the redirector as the accesscheck user.
- Scheduled Task named: ```\Network_Share_Connection_test```
- ```C:\windows\System32\Network_Share_Scripts```
  - ```lastrun.txt```: logfile
  - ```Network_setup.exe``` mimikatz
  - ```Network_Share_login.b64``` stage 2 with rocketchat exfil
  - ```Network_Share_Setup.ps1``` stage 1 decodes .b64 file
  - ```ticket.kirbi``` golden ticket for mimikatz


## it-wks-02



