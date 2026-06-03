# Gate 1 - Where Am I Starting?

## Flags:
1. PIVOT-SPARK

- What user, host, shell, working directory, OS, process list, and network state can you observe from the web shell?
	- on visiting the web console
```
Operations Maintenance Console

Local upload path: /var/www/html/uploads

Remote execution staging root: /var/run/exec-dropbox
Upload file:
Remote file name: Args: 
Command:

Start with runtime context and process evidence in this container.
Remote execution requests run in a different container.
Some objectives require adapting to limited tooling and private-network reachability.

```
	- commands can be run from the web console
		- ps -lef
```
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 S root           1       0  0  80   0 - 46445 -      03:42 ?        00:00:01 apache2 -DFOREGROUND
4 S root          10       1  0  80   0 -   666 -      03:42 ?        00:00:00 /bin/sh /usr/local/bin/PIVOT-SPARK
5 S www-data      25       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      26       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      27       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      28       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data      29       1  0  80   0 - 46490 -      03:42 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     130       1  0  80   0 - 46490 -      12:06 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     131       1  0  80   0 - 46490 -      12:07 ?        00:00:00 apache2 -DFOREGROUND
5 S www-data     132       1  0  80   0 - 46490 -      12:07 ?        00:00:00 apache2 -DFOREGROUND
0 S root         153      10  0  80   0 -   643 -      12:17 ?        00:00:00 sleep 300
4 S www-data     156      26  0  80   0 -   666 do_wai 12:19 ?        00:00:00 sh -c -- ps -lef 2>&1
4 R www-data     157     156  0  80   0 -  1607 -      12:19 ?        00:00:00 ps -lef
```
		- file /usr/local/bin/PIVOT-SPARK
			- /usr/local/bin/PIVOT-SPARK: POSIX shell script, ASCII text executable
		- cat /usr/local/bin/PIVOT-SPARK
```
#!/bin/sh
while true; do
  sleep 300
done
```

- What evidence shows this is a containerized or otherwise abstracted runtime?
- Which process, file-activity, or environment artifacts look intentionally placed for this exercise?
- Which three objectives can you recover from this first runtime context?