import QtQuick

Item {
    id: root

    property real spacing: 8

    signal surfaceRequested(string newName, var payload)
    signal powerRequested

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.spacing

        EyeToggle {}

        PomodoroToggle {}

        SettingsToggle {
            onSurfaceRequested: root.surfaceRequested(newName, payload)
        }

        BatteryToggle {
            onSurfaceRequested: root.surfaceRequested(newName, payload)
        }

        PowerToggle {
            onPowerRequested: root.powerRequested()
        }
    }
}
