# Redirector Info: (Reverse tunnel to adversary)
- `$SshExe = "$env:WINDIR\System32\OpenSSH\ssh.exe"' - from Inner-ReverseTunnel.ps1
- ` RedirectorUser = "accesscheck"` - from Inner-ReverseTunnel.ps1
- ` RedirectorHost = "203.0.113.150" - from Inner-ReverseTunnel.ps1
- ` RemotePort = 55985 - from Inner-ReverseTunnel.ps1
- ` LocalWinRMPort = 5985 - from Inner-ReverseTunnel.ps1
- ` $k=counterstrike (possible password) - from Invoke-WuModule.ps1
-  keyfile = `C:\ProgramData\Microsoft\Windows\PowerShell\ModuleAnalysisCache\Components\WUModel\runtime\pk.dat  - from Invoke-WuModule.ps1
	- `IFUpPgYKFQEVHy0KEQIzOAcXFx0AGxQdNzIKAREBAxYuMBURAQ4WPxwBAQYALhoQLQwPV1ZaRFc=`

# Teamserver: (Used to collect exfil)
- $RocketChatUrl = "203.0.113.150:3000" - from Network_Share_Login.b64
- $UserId        = "fZvfWT7BbNHDgAgRG" - from Network_Share_Login.b64
- $AuthToken     = "MhbQ_Bh0ETL6TaEZ_4jZdYT-fJpxlLz-Y9KxbL3B190" - from Network_Share_Login.b64