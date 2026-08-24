pragma Singleton

import QtCore
import QtQuick
import Quickshell

// Единый резолв путей для всей экосистемы.
// Без захардкоженных пользовательских путей — всё через переменные окружения и XDG.
QtObject {
    id: root

    /// XDG_CONFIG_HOME или дефолт ~/.config
    readonly property string xdgConfigHome: homeDir + "/.config"

    /// Домашняя директория
    readonly property string homeDir: String(StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]).replace(/^file:\/\//, "")

    /// ~/.config/quickshell/
    readonly property string configDir: xdgConfigHome + "/quickshell"

    /// Путь к палитре: env PALETTE_PATH → ~/.config/quickshell/colors.json
    readonly property string palettePath: Quickshell.env("PALETTE_PATH") ?? configDir + "/colors.json"
}
