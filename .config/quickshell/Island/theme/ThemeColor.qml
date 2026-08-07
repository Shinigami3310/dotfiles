pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Токены Material 3 из ~/.config/quickshell/colors.json с hot-reload.
// Если файл отсутствует или битый — используется дефолтная палитра,
// чтобы интерфейс никогда не становился прозрачным/невидимым.
QtObject {
    id: root

    readonly property string palettePath: Paths.palettePath

    // Дефолтная палитра (Material 3 light) — fallback при отсутствии/ошибке файла.
    readonly property var defaultColors: ({
            "primary": "#6750a4",
            "on_primary": "#ffffff",
            "primary_container": "#eaddff",
            "on_primary_container": "#21005d",
            "secondary": "#625b71",
            "on_secondary": "#ffffff",
            "secondary_container": "#e8def8",
            "on_secondary_container": "#1d192b",
            "tertiary": "#7d5260",
            "on_tertiary": "#ffffff",
            "tertiary_container": "#ffd8e4",
            "on_tertiary_container": "#31111d",
            "error": "#b3261e",
            "on_error": "#ffffff",
            "error_container": "#f9dedc",
            "on_error_container": "#410e0b",
            "surface": "#fef7ff",
            "on_surface": "#1d1b20",
            "on_surface_variant": "#49454f",
            "surface_container_lowest": "#ffffff",
            "surface_container_low": "#f7f2fa",
            "surface_container": "#f3edf7",
            "surface_container_high": "#ece6f0",
            "surface_container_highest": "#e6e0e9",
            "outline": "#79747e",
            "outline_variant": "#cac4d0",
            "inverse_surface": "#322f35",
            "inverse_on_surface": "#f5eff7",
            "inverse_primary": "#d0bcff"
        })

    property var parsedColors: defaultColors

    readonly property color primary: parsedColors.primary || defaultColors.primary
    readonly property color on_primary: parsedColors.on_primary || defaultColors.on_primary
    readonly property color primary_container: parsedColors.primary_container || defaultColors.primary_container
    readonly property color on_primary_container: parsedColors.on_primary_container || defaultColors.on_primary_container

    readonly property color secondary: parsedColors.secondary || defaultColors.secondary
    readonly property color on_secondary: parsedColors.on_secondary || defaultColors.on_secondary
    readonly property color secondary_container: parsedColors.secondary_container || defaultColors.secondary_container
    readonly property color on_secondary_container: parsedColors.on_secondary_container || defaultColors.on_secondary_container

    readonly property color tertiary: parsedColors.tertiary || defaultColors.tertiary
    readonly property color on_tertiary: parsedColors.on_tertiary || defaultColors.on_tertiary
    readonly property color tertiary_container: parsedColors.tertiary_container || defaultColors.tertiary_container
    readonly property color on_tertiary_container: parsedColors.on_tertiary_container || defaultColors.on_tertiary_container

    readonly property color error: parsedColors.error || defaultColors.error
    readonly property color on_error: parsedColors.on_error || defaultColors.on_error
    readonly property color error_container: parsedColors.error_container || defaultColors.error_container
    readonly property color on_error_container: parsedColors.on_error_container || defaultColors.on_error_container

    readonly property color surface: parsedColors.surface || defaultColors.surface
    readonly property color on_surface: parsedColors.on_surface || defaultColors.on_surface
    readonly property color on_surface_variant: parsedColors.on_surface_variant || defaultColors.on_surface_variant
    readonly property color surface_container_lowest: parsedColors.surface_container_lowest || defaultColors.surface_container_lowest
    readonly property color surface_container_low: parsedColors.surface_container_low || defaultColors.surface_container_low
    readonly property color surface_container: parsedColors.surface_container || defaultColors.surface_container
    readonly property color surface_container_high: parsedColors.surface_container_high || defaultColors.surface_container_high
    readonly property color surface_container_highest: parsedColors.surface_container_highest || defaultColors.surface_container_highest

    readonly property color outline: parsedColors.outline || defaultColors.outline
    readonly property color outline_variant: parsedColors.outline_variant || defaultColors.outline_variant
    readonly property color inverse_surface: parsedColors.inverse_surface || defaultColors.inverse_surface
    readonly property color inverse_on_surface: parsedColors.inverse_on_surface || defaultColors.inverse_on_surface
    readonly property color inverse_primary: parsedColors.inverse_primary || defaultColors.inverse_primary

    // Единая точка обновления палитры: парсит JSON и валидирует структуру.
    // При ошибке оставляет предыдущую палитру (или дефолтную) и логирует warn.
    function updateColors() {
        let fileContent = typeof paletteFile.text === "function" ? paletteFile.text() : paletteFile.text;
        if (!fileContent)
            return;

        try {
            let json = JSON.parse(fileContent);
            if (json && typeof json.colors === "object" && json.colors !== null) {
                root.parsedColors = json.colors;
            } else {
                console.warn("[ThemeColor] colors.json не содержит поля 'colors' — оставляю текущую палитру.");
            }
        } catch (e) {
            console.warn(`[ThemeColor] Ошибка парсинга colors.json: ${e.message} — оставляю текущую палитру.`);
        }
    }

    readonly property FileView fileview: FileView {
        id: paletteFile
        path: root.palettePath
        blockLoading: true
        watchChanges: true

        // Первичная загрузка палитры при старте.
        onLoadedChanged: {
            if (loaded) {
                root.updateColors();
            }
        }

        // Hot-reload при изменении файла. watchChanges сам перечитывает
        // содержимое, поэтому reload() не нужен — иначе парсинг выполнится дважды.
        onFileChanged: {
            root.updateColors();
        }
    }
}
