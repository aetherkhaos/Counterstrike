# Site:
[The C2 Matrix | C2 Matrix](https://howto.thec2matrix.com/)

# Havoc

Wiki: [https://github.com/HavocFramework/Havoc/blob/main/WIKI.MD](https://github.com/HavocFramework/Havoc/blob/main/WIKI.MD)

## Run Havoc Team Server

Copy

```
cd /opt/Havoc/Teamserver
sudo ./teamserver server --profile ./profiles/havoc.yaotl -v --debug
```

## Run Havoc Client

Copy

```
cd /opt/Havoc/Client
sudo ./Havoc
```

## Login to Havoc

Teamserver information is in /opt/Havoc/Teamserver/profiles/havoc.yaotl

To authenticate:

Copy

```
Name: Slingshot
Host: localhost
Port: 40056
Username: Neo
Password: password1234
```

## Start a Listener

Click "View" on the top left menu of the Havoc client then click "Listeners". In the bottom screen that opens, Click "Add"

In the new window that pops up, give the Listener a Name and modify any options you would like to change. Then click Save.

## 

[](https://howto.thec2matrix.com/c2/havoc#create-payload)

Create Payload

Click "Attack" on the top left menu of the Havoc client and then click "Payload". In the new window, select your Listener, Arch, Format, and modify any configuration, then click "Generate". Note this takes a little bit of time. Once the payload is compiled, it will ask you to save it somewhere. To host it with apache, save it at /var/www/html/demon.exe

Start Apache to host the file:

Copy

```
sudo service apache2 start
```

## 

[](https://howto.thec2matrix.com/c2/havoc#download-and-execute)

Download and Execute

On the target system, open a browser to http://IPAddress/demon.exe

Download and double click demon.exe to launch.

Go back to your Havoc client to interact with the implant.