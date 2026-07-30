import QtQuick

Item {
    id: root

    property real spacing: 8

    signal surfaceRequested(string newName)
    signal powerRequested

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.spacing

        EyeToggle {}

        PomodoroToggle {}

        SettingsToggle {
            onSurfaceRequested: root.surfaceRequested("controlPanel")
        }

        BatteryToggle {
            onSurfaceRequested: (newName) => root.surfaceRequested(newName)
        }

        PowerToggle {}
    }
}
