#!/usr/bin/env sh
set -eu

export HOME="${HOME:-/paperclip}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-$HOME}"
export HOST="${HOST:-0.0.0.0}"

INSTANCE_ID="${PAPERCLIP_INSTANCE_ID:-default}"
mkdir -p "$PAPERCLIP_HOME" "$PAPERCLIP_HOME/instances/$INSTANCE_ID/logs"

# Fix volume permissions and run as non-root user
if [ "$(id -u)" = "0" ]; then
  chown -R paperclip:paperclip /paperclip /app /opt/paperclip 2>/dev/null || true
  
  # Railway usually provides only the hostname
  if [ -z "${PAPERCLIP_PUBLIC_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    export PAPERCLIP_PUBLIC_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
  fi
  
  exec gosu paperclip node /app/src/server.js
fi

# Fallback if somehow not root
if [ -z "${PAPERCLIP_PUBLIC_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    export PAPERCLIP_PUBLIC_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

exec node /app/src/server.js
