pragma Singleton

import QtQuick
import QtCore
import Quickshell

QtObject {
    id: root

    readonly property string homeDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] ?? "/home/rostislav"
    readonly property string configDir: homeDir + "/.config/quickshell"
    readonly property string assetsDir: Qt.resolvedUrl("../assets/").toString().replace("file://", "")
    readonly property string scriptsDir: Qt.resolvedUrl("../services/scripts/").toString().replace("file://", "")
    readonly property string palettePath: configDir + "/colors.json"

    readonly property string notificationCenterConfig: "NotificationCenter"
    readonly property string powerMenuConfig: "PowerMenu"
    readonly property string defaultTerminal: "kitty"
    readonly property string pomodoroIcon: assetsDir + "PomodoroService.png"

    // Каталоги .desktop-файлов для AppService.
    readonly property list<string> appDirs: [homeDir + "/.local/share/applications", "/usr/share/applications"]

    // Иконки резолвятся через единый путь, а не относительный — иначе
    // компонент из другой папки (например ui/ и features/) получит
    // разный базовый каталог и сломается.
    function icon(name: string): string {
        return assetsDir + "icons/" + name;
    }
}
