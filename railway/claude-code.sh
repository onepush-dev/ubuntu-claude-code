# Claude Code defaults for every login shell (browser and SSH).
# The CLI is installed globally by root, so self-updates are off; update with:
#   sudo npm install -g @anthropic-ai/claude-code@latest
export DISABLE_AUTOUPDATER=1
[ -r /etc/railway-claude.env ] && . /etc/railway-claude.env
