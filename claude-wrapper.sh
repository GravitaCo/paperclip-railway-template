#!/usr/bin/env sh
# Wrapper that runs Claude Code as a non-root user
exec gosu paperclip /usr/local/bin/claude-real "$@"
