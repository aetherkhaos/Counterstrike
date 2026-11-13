#!/bin/bash
# Install OpenCode on this machine and point it at the team Spark.
# Tokens stay in the home directory. This script does not print them.
set -euo pipefail

read -r -p "Team number (1-4): " team
case "$team" in
  1|2|3|4) ;;
  *)
    echo "Team number must be 1, 2, 3, or 4." >&2
    exit 1
    ;;
esac

read -r -s -p "LiteLLM key: " litellm_key
echo
read -r -s -p "GitLab personal access token (api and write_repository): " gitlab_token
echo
if [ -z "$litellm_key" ] || [ -z "$gitlab_token" ]; then
  echo "Both values are required." >&2
  exit 1
fi

if ! command -v opencode >/dev/null 2>&1; then
  echo "Installing OpenCode..."
  if ! curl -fsSL https://opencode.ai/install | bash; then
    echo "OpenCode install failed. See https://opencode.ai/install" >&2
    exit 1
  fi
fi

export TEAM_NUMBER="$team"
export LITELLM_KEY="$litellm_key"
export GITLAB_TOKEN="$gitlab_token"
python3 - <<'PY'
import json
import os
from pathlib import Path

team = os.environ["TEAM_NUMBER"]
config_dir = Path.home() / ".config" / "opencode"
config_dir.mkdir(parents=True, exist_ok=True)
config_path = config_dir / "opencode.json"
existing: dict = {}
if config_path.is_file():
    existing = json.loads(config_path.read_text(encoding="utf-8"))
provider = existing.setdefault("provider", {})
litellm = provider.setdefault("litellm", {})
litellm["npm"] = "@ai-sdk/openai-compatible"
litellm["name"] = "LiteLLM"
options = litellm.setdefault("options", {})
options["baseURL"] = f"https://litellm.team{team}.cso.ops/v1"
options["apiKey"] = os.environ["LITELLM_KEY"]
models = litellm.setdefault("models", {})
models["ollama/qwen3.8:27b"] = {"name": "ollama/qwen3.8:27b"}
enabled = existing.setdefault("enabled_providers", [])
if "litellm" not in enabled:
    enabled.append("litellm")
existing["model"] = "litellm/ollama/qwen3.8:27b"
existing["small_model"] = "litellm/ollama/qwen3.8:27b"
config_path.write_text(json.dumps(existing, indent=2) + "\n", encoding="utf-8")
config_path.chmod(0o600)
env_path = config_dir / "trainer-review.env"
env_path.write_text(
    "GITLAB_TOKEN="
    + os.environ["GITLAB_TOKEN"]
    + "\nNODE_TLS_REJECT_UNAUTHORIZED=0\nGIT_SSL_NO_VERIFY=true\n",
    encoding="utf-8",
)
env_path.chmod(0o600)
print(config_path)
print(env_path)
PY
unset LITELLM_KEY GITLAB_TOKEN TEAM_NUMBER

bashrc="$HOME/.bashrc"
marker="# trainer-review-opencode"
source_line='[ -f "$HOME/.config/opencode/trainer-review.env" ] && set -a && . "$HOME/.config/opencode/trainer-review.env" && set +a'
if ! grep -q "$marker" "$bashrc" 2>/dev/null; then
  printf '\n%s\n%s\n' "$marker" "$source_line" >> "$bashrc"
fi

cat <<EOF

OpenCode uses https://litellm.team${team}.cso.ops/v1 and model ollama/qwen3.8:27b.
Certificate checks are off for that process so the team gateway and GitLab can
use their current certificates. The GitLab token is loaded from
~/.config/opencode/trainer-review.env. Do not commit it or put it in a git remote.

This session does not see those settings, and a newly installed opencode command
is not on this session's PATH. Close this session and open a new one, then start
opencode from that shell inside this repository.
EOF
