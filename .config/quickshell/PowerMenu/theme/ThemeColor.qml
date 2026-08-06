pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string palettePath: "/home/Rostislav/.config/quickshell/colors.json"

    property var parsedColors: ({})

    readonly property color primary: parsedColors.primary || "transparent"
    readonly property color on_primary: parsedColors.on_primary || "transparent"
    readonly property color primary_container: parsedColors.primary_container || "transparent"
    readonly property color on_primary_container: parsedColors.on_primary_container || "transparent"

    readonly property color secondary: parsedColors.secondary || "transparent"
    readonly property color on_secondary: parsedColors.on_secondary || "transparent"
    readonly property color secondary_container: parsedColors.secondary_container || "transparent"
    readonly property color on_secondary_container: parsedColors.on_secondary_container || "transparent"

    readonly property color tertiary: parsedColors.tertiary || "transparent"
    readonly property color on_tertiary: parsedColors.on_tertiary || "transparent"
    readonly property color tertiary_container: parsedColors.tertiary_container || "transparent"
    readonly property color on_tertiary_container: parsedColors.on_tertiary_container || "transparent"

    readonly property color error: parsedColors.error || "transparent"
    readonly property color on_error: parsedColors.on_error || "transparent"
    readonly property color error_container: parsedColors.error_container || "transparent"
    readonly property color on_error_container: parsedColors.on_error_container || "transparent"

    readonly property color surface: parsedColors.surface || "transparent"
    readonly property color on_surface: parsedColors.on_surface || "transparent"
    readonly property color on_surface_variant: parsedColors.on_surface_variant || "transparent"
    readonly property color surface_container_lowest: parsedColors.surface_container_lowest || "transparent"
    readonly property color surface_container_low: parsedColors.surface_container_low || "transparent"
    readonly property color surface_container: parsedColors.surface_container || "transparent"
    readonly property color surface_container_high: parsedColors.surface_container_high || "transparent"
    readonly property color surface_container_highest: parsedColors.surface_container_highest || "transparent"

    readonly property color outline: parsedColors.outline || "transparent"
    readonly property color outline_variant: parsedColors.outline_variant || "transparent"
    readonly property color inverse_surface: parsedColors.inverse_surface || "transparent"
    readonly property color inverse_on_surface: parsedColors.inverse_on_surface || "transparent"
    readonly property color inverse_primary: parsedColors.inverse_primary || "transparent"

    readonly property FileView fileview: FileView {
        id: paletteFile
        path: root.palettePath
        blockLoading: true
        watchChanges: true

        function updateColors() {
            let fileContent = typeof paletteFile.text === "function" ? paletteFile.text() : paletteFile.text;

            let json = JSON.parse(fileContent);
            root.parsedColors = json.colors;
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
