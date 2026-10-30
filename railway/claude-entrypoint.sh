#!/bin/bash
# Pass optional Claude Code settings from Railway variables to login shells, then start
# the base web-terminal entrypoint (ttyd + sshd + tmux).
set -euo pipefail
U="${TERMINAL_USER:-ubuntu}"
: > /etc/railway-claude.env
for v in ANTHROPIC_API_KEY ANTHROPIC_BASE_URL ANTHROPIC_MODEL CLAUDE_CODE_USE_BEDROCK CLAUDE_CODE_USE_VERTEX; do
  if [ -n "${!v:-}" ]; then printf 'export %s=%q\n' "$v" "${!v}" >> /etc/railway-claude.env; fi
done
# Readable only by root and the terminal user's group (created by the base entrypoint if missing).
id "$U" >/dev/null 2>&1 || useradd -m -s /bin/bash -G sudo "$U"
chown root:"$(id -gn "$U")" /etc/railway-claude.env
chmod 640 /etc/railway-claude.env
exec /usr/local/bin/entrypoint.sh
