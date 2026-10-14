gain access: 
-  10.1.10.111

remote:
- 192.168.10.5
- ports: get request to 7001-7020

---

jumpbox
	interfaces:
		ens34: 192.168.10.111
		ens37: 10.1.10.111

---

`ssh -v -i ./key -R 0.0.0.0:7011:localhost:12345 user@10.1.10.111`