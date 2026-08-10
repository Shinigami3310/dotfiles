pragma Singleton

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io

// Токены Material 3 из colors.json с hot-reload — единый источник для всей экосистемы.
// Самодостаточен: не зависит от конфигов конкретного подпроекта.
// Путь к палитре: env PALETTE_PATH → ~/.config/quickshell/colors.json.
QtObject {
    id: root

    property color primary: parsedColors.primary ?? _defaultPalette.primary
    property color on_primary: parsedColors.on_primary ?? _defaultPalette.on_primary
    property color primary_container: parsedColors.primary_container ?? _defaultPalette.primary_container
    property color on_primary_container: parsedColors.on_primary_container ?? _defaultPalette.on_primary_container

    property color secondary: parsedColors.secondary ?? _defaultPalette.secondary
    property color on_secondary: parsedColors.on_secondary ?? _defaultPalette.on_secondary
    property color secondary_container: parsedColors.secondary_container ?? _defaultPalette.secondary_container
    property color on_secondary_container: parsedColors.on_secondary_container ?? _defaultPalette.on_secondary_container

    property color tertiary: parsedColors.tertiary ?? _defaultPalette.tertiary
    property color on_tertiary: parsedColors.on_tertiary ?? _defaultPalette.on_tertiary
    property color tertiary_container: parsedColors.tertiary_container ?? _defaultPalette.tertiary_container
    property color on_tertiary_container: parsedColors.on_tertiary_container ?? _defaultPalette.on_tertiary_container

    property color error: parsedColors.error ?? _defaultPalette.error
    property color on_error: parsedColors.on_error ?? _defaultPalette.on_error
    property color error_container: parsedColors.error_container ?? _defaultPalette.error_container
    property color on_error_container: parsedColors.on_error_container ?? _defaultPalette.on_error_container

    property color surface: parsedColors.surface ?? _defaultPalette.surface
    property color on_surface: parsedColors.on_surface ?? _defaultPalette.on_surface
    property color on_surface_variant: parsedColors.on_surface_variant ?? _defaultPalette.on_surface_variant
    property color surface_container_lowest: parsedColors.surface_container_lowest ?? _defaultPalette.surface_container_lowest
    property color surface_container_low: parsedColors.surface_container_low ?? _defaultPalette.surface_container_low
    property color surface_container: parsedColors.surface_container ?? _defaultPalette.surface_container
    property color surface_container_high: parsedColors.surface_container_high ?? _defaultPalette.surface_container_high
    property color surface_container_highest: parsedColors.surface_container_highest ?? _defaultPalette.surface_container_highest

    property color outline: parsedColors.outline ?? _defaultPalette.outline
    property color outline_variant: parsedColors.outline_variant ?? _defaultPalette.outline_variant
    property color inverse_surface: parsedColors.inverse_surface ?? _defaultPalette.inverse_surface
    property color inverse_on_surface: parsedColors.inverse_on_surface ?? _defaultPalette.inverse_on_surface
    property color inverse_primary: parsedColors.inverse_primary ?? _defaultPalette.inverse_primary

    /// Прозрачный цвет — единый токен вместо хардкода "transparent".
    readonly property color transparent: "transparent"

    /// Сырые цвета из файла (JSON-объект, ключи — токены M3).
    property var parsedColors: ({})

    /// Дефолтная палитра Material 3 light — fallback при отсутствии/ошибке файла.
    readonly property var _defaultPalette: ({
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

    /// Путь к палитре: env PALETTE_PATH → ~/.config/quickshell/colors.json.
    readonly property string palettePath: {
        const fromEnv = Quickshell.env("PALETTE_PATH");
        if (fromEnv)
            return fromEnv;
        const xdg = Quickshell.env("XDG_CONFIG_HOME")
            ?? StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] + "/.config";
        return xdg + "/quickshell/colors.json";
    }

    // Наблюдатель за изменениями файла: перезагрузка + обновление токенов.
    readonly property FileView paletteFile: FileView {
        id: fileView
        path: root.palettePath
        blockLoading: true
        watchChanges: true

        onFileChanged: fileView.reload()

        adapter: JsonAdapter {
            id: jsonAdapter

            property var colors

            onColorsChanged: {
                if (colors !== undefined && colors !== null) {
                    root.parsedColors = colors;
                }
            }
        }
    }
}