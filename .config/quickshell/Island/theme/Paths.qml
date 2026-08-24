pragma Singleton

import QtQuick
import QtCore

QtObject {
    id: root

    readonly property string homeDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] ?? "/home/rostislav"
    readonly property string assetsDir: Qt.resolvedUrl("../assets/").toString().replace("file://", "")
    readonly property string scriptsDir: Qt.resolvedUrl("../services/scripts/").toString().replace("file://", "")

    readonly property string notificationCenterConfig: "NotificationCenter"
    readonly property string powerMenuConfig: "PowerMenu"
    readonly property string defaultTerminal: "kitty"

    readonly property list<string> appDirs: [homeDir + "/.local/share/applications", "/usr/share/applications"]

    function icon(name: string): string {
        return assetsDir + "icons/" + name;
    }
}
