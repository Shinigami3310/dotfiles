pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Синглтон палитры. Читает colors.json (генерируется matugen при смене обоев)
// через FileView с watchChanges — палитра обновляется реактивно без перезапуска.
// Fallback-цвета (тёмная тема) используются, если файл недоступен или битый.
QtObject {
    id: root

    readonly property string palettePath: "/home/Rostislav/.config/quickshell/colors.json"

    property var parsedColors: ({})

    readonly property color primary: parsedColors.primary || "#81cfff"
    readonly property color on_primary: parsedColors.on_primary || "#00344b"
    readonly property color primary_container: parsedColors.primary_container || "#004c6b"
    readonly property color on_primary_container: parsedColors.on_primary_container || "#c6e7ff"

    readonly property color secondary: parsedColors.secondary || "#b2c8e8"
    readonly property color on_secondary: parsedColors.on_secondary || "#1b324b"
    readonly property color secondary_container: parsedColors.secondary_container || "#334863"
    readonly property color on_secondary_container: parsedColors.on_secondary_container || "#d2e4ff"

    readonly property color tertiary: parsedColors.tertiary || "#b6c5f9"
    readonly property color on_tertiary: parsedColors.on_tertiary || "#1f2e5a"
    readonly property color tertiary_container: parsedColors.tertiary_container || "#364572"
    readonly property color on_tertiary_container: parsedColors.on_tertiary_container || "#dbe1ff"

    readonly property color error: parsedColors.error || "#ffb4ab"
    readonly property color on_error: parsedColors.on_error || "#690005"
    readonly property color error_container: parsedColors.error_container || "#93000a"
    readonly property color on_error_container: parsedColors.on_error_container || "#ffdad6"

    readonly property color surface: parsedColors.surface || "#0b141a"
    readonly property color on_surface: parsedColors.on_surface || "#dae4ec"
    readonly property color on_surface_variant: parsedColors.on_surface_variant || "#bec8d0"
    readonly property color surface_container_lowest: parsedColors.surface_container_lowest || "#060f15"
    readonly property color surface_container_low: parsedColors.surface_container_low || "#141d23"
    readonly property color surface_container: parsedColors.surface_container || "#182127"
    readonly property color surface_container_high: parsedColors.surface_container_high || "#222b32"
    readonly property color surface_container_highest: parsedColors.surface_container_highest || "#2d363d"

    readonly property color outline: parsedColors.outline || "#88929a"
    readonly property color outline_variant: parsedColors.outline_variant || "#3f484f"
    readonly property color inverse_surface: parsedColors.inverse_surface || "#dae4ec"
    readonly property color inverse_on_surface: parsedColors.inverse_on_surface || "#283238"
    readonly property color inverse_primary: parsedColors.inverse_primary || "#00658d"

    readonly property FileView paletteFile: FileView {
        path: root.palettePath
        blockLoading: true
        watchChanges: true

        function updateColors() {
            let fileContent = typeof paletteFile.text === "function" ? paletteFile.text() : paletteFile.text;
            try {
                let json = JSON.parse(fileContent);
                root.parsedColors = json.colors;
            } catch (e) {
                // Битый JSON — оставляем текущую палитру (или fallback), UI не падает.
                console.warn("[ThemeColor] Не удалось распарсить colors.json:", e);
            }
        }

        onLoadedChanged: {
            if (loaded) {
                updateColors();
            }
        }

        onFileChanged: {
            paletteFile.reload();
            updateColors();
        }
    }
}