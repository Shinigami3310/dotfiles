pragma Singleton
import QtQuick

QtObject {
    readonly property var importance: ({
            low: "low",
            normal: "normal",
            critical: "critical"
        })
    readonly property var origin: ({
            dbus: "dbus",
            api: "api"
        })
}
