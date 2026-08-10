#!/usr/bin/env bash
# Toggle Theme Picker: if already running — close, otherwise — open.
# Uses pgrep instead of a PID file: more reliable, does not depend on /tmp
# and does not break on garbage file content.
set -euo pipefail

CONFIG_DIR="$HOME/.config/quickshell/ThemePicker"
# Find the quickshell process started with this config, so we don't
# touch other quickshell instances.
PID="$(pgrep -f "quickshell -p .*$CONFIG_DIR" | head -n1 || true)"

if [[ -n "$PID" ]]; then
    # Already running — close
    kill "$PID" 2>/dev/null || true
    exit 0
fi

# Not running — open
quickshell -p "$CONFIG_DIR/shell.qml" &