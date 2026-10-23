Range support copies this directory onto each student VM and starts it before class. Students do not install n8n. The same directory is used on a classroom VM and on a PCTE HWIL VM.

n8n is `http://localhost:5678` on that VM. The image is `docker.n8n.io/n8nio/n8n:2.39.5`. This stack has its own Compose network. It does not join `web`, it does not set Traefik labels, and it does not publish ports 80 or 443.

The VM already has Docker and the Compose plugin. This directory does not install them. It can reach the team DGX on the classroom LAN. Save the classroom root at `certs/root_ca.crt` before the first start. The file must be a certificate, not a directory Compose created because the file was missing.

```
curl -fsS http://trust.cso.ops/root_ca.crt -o /tmp/root_ca.crt
curl -fsS http://trust.cso.ops/root_ca.fingerprint
openssl x509 -in /tmp/root_ca.crt -noout -fingerprint -sha256
mkdir -p certs
cp /tmp/root_ca.crt certs/root_ca.crt
```

The two fingerprints must match. A leaf from one team box is not a CA. Do not copy `team.crt` here.

```
cp env.example .env
mkdir -p vols/n8n vols/chroma lab_data certs
sudo chown -R 1000:1000 vols/n8n
docker compose -p student-n8n up -d
./scripts/check-student-n8n.sh
```

Chroma is the vector database for the Effects Advisor lab. It is already in this compose, on `student_n8n`, image `chromadb/chroma:1.0.21`. n8n reaches it at `http://chroma:8000`. The index script on the VM uses `[http://127.0.0.1:8000](http://127.0.0.1:8000)`. Heartbeat: `curl -sS [http://127.0.0.1:8000/api/v2/heartbeat](http://127.0.0.1:8000/api/v2/heartbeat)`. Collection name is `doctrine_index`. `vols/chroma` is that database. Do not commit it.

n8n runs as uid 1000. `vols/n8n` must be writable by that user or the container exits with `EACCES` on `/home/node/.n8n/config`. `lab_data` stays readable by that user. Students copy `auth_syslog.txt` into it.

`-p student-n8n` keeps this stack off any other Compose project already set in the shell.

Leave `N8N_RESTRICT_FILE_ACCESS_TO` unset. The lab has students hit the file-access error, then set that variable to `/lab_data` and recreate the container. `NODE_FUNCTION_ALLOW_BUILTIN=fs` is set so the Effects Advisor code node can `require('fs')` and write `/lab_data/runs`. The path gate still applies.

`lab_data/` on the host is `/lab_data` in the container. Students copy `auth_syslog.txt` there, and later the doctrine notes and incident JSON. `vols/n8n` is n8n's own state. Do not put the syslog under `vols/n8n`.

The VM must reach the team LiteLLM URL and the class CTI API. Students take the LiteLLM URL and key from the Moodle page **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**. `NODE_EXTRA_CA_CERTS` points at the mounted `certs/root_ca.crt`. The OpenAI Chat Model node has no ignore-SSL option. A missing or untrusted certificate shows up there as `Connection error`.