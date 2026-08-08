#!/usr/bin/env bash
# toggleThemePicker.sh — бинд Hyprland: открыть, если picker не запущен, иначе закрыть.
# Поведение:
#  - UI‑окно открывается само при старте shell (ThemePickerWindow.Component.onCompleted → open).
#  - Esc / Enter внутри окна → плавный fade‑out → Qt.quit() → shell выгружается из памяти.
#  - Повторный бинд, когда окно открыто: посылаем SIGTERM (закрытие без fade — допустимо,
#    плавность обязана только клавиатуре: Esc/Enter).
#
# Пример строки в ~/.config/hypr/hyprland.conf:
#   bind = $mod, P, exec, ~/.config/quickshell/ThemePicker/scripts/toggleThemePicker.sh
set -euo pipefail

CONFIG="ThemePicker"
PATTERN="quickshell.*-c ${CONFIG}"

if pgrep -f "${PATTERN}" >/dev/null 2>&1; then
    # Уже запущен → закрываем (kill также уберёт окно).
    pkill -TERM -f "${PATTERN}"
else
    # Quickshell дедупит экземпляры по имени конфига — повторный запуск не создаст дубликат окна.
    setsid quickshell -c "${CONFIG}" >/dev/null 2>&1 < /dev/null &
fi
