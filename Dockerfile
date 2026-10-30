# Ubuntu 26.04 LTS + Claude Code: browser terminal (ttyd) and SSH on one persistent tmux session.
# Built on onepush-dev/ubuntu-web-terminal (ttyd 1.7.7 sha-verified, OpenSSH, tmux).
ARG BASE_IMAGE=ghcr.io/onepush-dev/ubuntu-web-terminal:26.04-ttyd1.7.7@sha256:299c59b7183d29fda699939165cbe40b22f226ce1386cc5da05e7c751ae96bd3
FROM ${BASE_IMAGE}

ARG CLAUDE_CODE_VERSION=2.1.314
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends nodejs npm ripgrep python3 python3-pip python3-venv build-essential \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g --no-fund --no-audit "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
 && npm cache clean --force \
 && node --version && claude --version

COPY --chmod=644 railway/claude-code.sh /etc/profile.d/claude-code.sh
COPY --chmod=755 railway/claude-entrypoint.sh /usr/local/bin/claude-entrypoint.sh

EXPOSE 7681 2222
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/claude-entrypoint.sh"]
