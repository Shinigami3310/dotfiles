#!/usr/bin/env bash
# Toggle Theme Picker: если уже запущен — закрыть, иначе — открыть.
# Использует pgrep вместо PID-файла: надёжнее, не зависит от /tmp
# и не ломается от мусорного содержимого файла.
set -euo pipefail

CONFIG_DIR="$HOME/.config/quickshell/ThemePicker"
# Ищем процесс quickshell, запущенный именно с этим конфигом, чтобы не
# задеть другие экземпляры quickshell.
PID="$(pgrep -f "quickshell -p .*$CONFIG_DIR" | head -n1 || true)"

if [[ -n "$PID" ]]; then
    # Уже запущен — закрываем
    kill "$PID" 2>/dev/null || true
    exit 0
fi

# Не запущен — открываем
quickshell -p "$CONFIG_DIR/shell.qml" &