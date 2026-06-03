# Gate 1 - Where Am I Starting?

- What user, host, shell, working directory, OS, process list, and network state can you observe from the web shell?
	- on visiting the web console
```
Operations Maintenance Console

Local upload path: /var/www/html/uploads

Remote execution staging root: /var/run/exec-dropbox
Upload file:
Remote file name: Args: Command:
Hints

Start with runtime context and process evidence in this container.
Remote execution requests run in a different container.
Some objectives require adapting to limited tooling and private-network reachability.

```
- What evidence shows this is a containerized or otherwise abstracted runtime?
- Which process, file-activity, or environment artifacts look intentionally placed for this exercise?
- Which three objectives can you recover from this first runtime context?