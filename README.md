# Ubuntu + Claude Code on Railway

Ubuntu 26.04 LTS with Anthropic's Claude Code CLI preinstalled, reachable from your browser and over real SSH, both attached to one persistent tmux session. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/TEMPLATE_CODE)

## What you get

- **Claude Code 2.1.314** installed globally (`claude`), plus Node.js, npm, Python 3, git, ripgrep and build-essential.
- **Browser terminal** (ttyd 1.7.7) on the public Railway domain, protected by HTTP basic auth.
- **Real SSH** through a Railway TCP proxy (sshd on port 2222), with host keys persisted on the volume so the fingerprint never changes.
- **One tmux session** (`main`) shared by the browser and SSH: start `claude` on your laptop, close the lid, pick it up from your phone.
- **Persistent `/home` volume**: your repos, `~/.claude` login, settings, history and MCP config survive redeploys.
- **Zero inputs**: a 24-character password is generated per deploy (`TERMINAL_PASSWORD`).

## How to use

1. Deploy the template and open the service's public URL. Log in as `ubuntu` with the `TERMINAL_PASSWORD` value from the service's Variables tab.
2. Run `claude`. Sign in with your Claude subscription (copy the login URL, paste the code back), or set an API key (below).
3. For SSH, open the service's Settings > Networking to find the TCP proxy host and port, then `ssh -p <port> ubuntu@<host>`. Interactive SSH logins auto-attach to the same tmux session.

## Optional variables

Add these on the service if you want them (they are not template inputs):

| Variable | Purpose |
|---|---|
| `ANTHROPIC_API_KEY` | Use an Anthropic Console API key instead of a subscription login. |
| `ANTHROPIC_BASE_URL` | Point Claude Code at a proxy or gateway (LiteLLM, 9Router, etc.). |
| `ANTHROPIC_MODEL` | Default model for Claude Code. |
| `CLAUDE_CODE_USE_BEDROCK` / `CLAUDE_CODE_USE_VERTEX` | Use Amazon Bedrock or Google Vertex AI (set their usual credentials too). |
| `SSH_AUTHORIZED_KEYS` | Public keys to add for SSH, separated by `;`. Then set `SSH_PASSWORD_AUTH=false` for key-only SSH. |

These are exported into every login shell (browser and SSH) from `/etc/railway-claude.env`, readable only by root and the terminal user.

## Template variables

| Variable | Default | Notes |
|---|---|---|
| `PORT` | `7681` | ttyd web terminal port behind the public domain |
| `SSH_PORT` | `2222` | sshd port, exposed by the TCP proxy |
| `TERMINAL_USER` | `ubuntu` | Linux user for browser and SSH |
| `TERMINAL_PASSWORD` | `${{secret(24)}}` | Generated per deploy |
| `SSH_PASSWORD_AUTH` | `true` | Set `false` for key-only SSH |
| `SUDO_NOPASSWD` | `true` | Passwordless sudo for the user |
| `TMUX_SESSION` | `main` | Shared tmux session name |
| `TMUX_AUTO_ATTACH` | `true` | SSH logins attach to the session |
| `TERMINAL_TITLE` | `Ubuntu + Claude Code` | Browser tab title |
| `TTYD_FONT_SIZE` | `15` | Browser terminal font size |
| `TTYD_MAX_CLIENTS` | `0` | Max browser clients (0 = unlimited) |
| `TZ` | `UTC` | Container timezone |

## Notes

- Claude Code self-updates are disabled because the CLI is installed system-wide. Update it with `sudo npm install -g @anthropic-ai/claude-code@latest`, or redeploy a newer image.
- Only `/home` is persistent. Packages installed with `apt` outside `/home` are lost on redeploy; install tools into your home directory or bake them into a fork of the image.
- The image is `ghcr.io/onepush-dev/ubuntu-claude-code:26.04-claude2.1.314`, built by GitHub Actions from this repo on top of [ubuntu-web-terminal](https://github.com/onepush-dev/ubuntu-web-terminal).
- Treat the terminal password like a root password: anyone with it can run code on the box.
