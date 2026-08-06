pragma Singleton

import QtQuick
import QtCore
import Quickshell

QtObject {
    id: root

    readonly property string homeDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] ?? "/home/rostislav"
    readonly property string configDir: homeDir + "/.config/quickshell"
    readonly property string assetsDir: Qt.resolvedUrl("../../assets").toString().replace("file://", "")
    readonly property string palettePath: configDir + "/colors.json"

    readonly property string notificationCenterConfig: "NotificationCenter"
    readonly property string powerMenuConfig: "PowerMenu"
    readonly property string defaultTerminal: "kitty"
    readonly property string pomodoroIcon: assetsDir + "/icons/PomodoroService.png"
}