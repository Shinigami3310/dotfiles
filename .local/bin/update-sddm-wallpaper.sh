#!/usr/bin/env bash

WALLPAPER_PATH="${1:-}"

THEME_DIR="/usr/share/sddm/themes/custom-astronaut"
MATUGEN_JSON="/home/Rostislav/.config/sddm/colors.json"

install -m 644 "$WALLPAPER_PATH" "$THEME_DIR/background.jpg"
install -m 644 "$MATUGEN_JSON" "$THEME_DIR/colors.json"
