```
PS C:\Users\Administrator> schtasks

Folder: \
TaskName                                 Next Run Time          Status
======================================== ====================== ===============
Network_Share_Connection_Test            6/5/2026 8:45:01 AM    Ready
Windows Module Analysis Cache            6/5/2026 11:15:00 AM   Ready
```

```
PS C:\Users\Administrator> gci C:\Windows\System32\Network_Share_Scripts\


    Directory: C:\Windows\System32\Network_Share_Scripts


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          6/5/2026   8:50 AM             35 lastrun.txt
-a----         3/27/2026   7:47 AM        1250056 Network_setup.exe
-a----         4/13/2026  12:48 PM           7454 Network_Share_Login.b64
-a----         4/13/2026  12:51 PM            485 Network_Share_Setup.ps1
```

PS C:\Users\Administrator> type C:\Windows\System32\Network_Share_Scripts\lastrun.txt
2026-06-05T08:50:01.5777641-04:00
PS C:\Users\Administrator> Get-FileHash -alg md5 C:\Windows\System32\Network_Share_Scripts\Network_setup.exe

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
MD5             E930B05EFE23891D19BC354A4209BE3E                                       C:\Windows\System32\Network_Share_Scripts\Network_setup.exe