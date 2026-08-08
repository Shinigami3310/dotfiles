#!/usr/bin/env bash
# Toggle Theme Picker: если уже запущен — закрыть, иначе — открыть.
# Использует PID-файл, чтобы не плодить дубликаты экземпляров.
set -euo pipefail

CONFIG_DIR="$HOME/.config/quickshell/ThemePicker"
PID_FILE="/tmp/theme-picker.pid"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    # Уже запущен — закрываем
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
    rm -f "$PID_FILE"
    exit 0
fi

# Не запущен — открываем
rm -f "$PID_FILE"
quickshell -p "$CONFIG_DIR/shell.qml" &
echo $! > "$PID_FILE"