#!/usr/bin/env bash

WALLPAPER_PATH="${1:-}"
THEME_DIR="/usr/share/sddm/themes/custom-astronaut"

# Путь к сгенерированному файлу colors.json от Matugen
MATUGEN_JSON="/home/Rostislav/.config/sddm/colors.json"

if [[ -z "$WALLPAPER_PATH" || ! -f "$WALLPAPER_PATH" ]]; then
  echo "Error: Image file '$WALLPAPER_PATH' does not exist." >&2
  exit 1
fi

# 1. Копируем обои
cp "$WALLPAPER_PATH" "$THEME_DIR/background.jpg"
chmod 644 "$THEME_DIR/background.jpg"

# 2. Копируем палитру Matugen (если существует)
echo $MATUGEN_JSON
if [[ -f "$MATUGEN_JSON" ]]; then
  cp "$MATUGEN_JSON" "$THEME_DIR/colors.json"
  chmod 644 "$THEME_DIR/colors.json"
fi
