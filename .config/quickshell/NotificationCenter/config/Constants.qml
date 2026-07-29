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
    readonly property var closeReason: ({
            expired: 1,
            dismissed: 2,
            closed: 3,
            undefined: 4
        })
}
