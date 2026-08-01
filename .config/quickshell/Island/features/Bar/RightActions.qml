import QtQuick
import "./RightButtons"

Row {
    id: root
    spacing: 8

    signal surfaceRequested(string newName)
    signal closeRequested

    EyeToggle {}

    PomodoroToggle {}

    SettingsToggle {
        onSurfaceRequested: newName => root.surfaceRequested(newName)
    }

    BatteryToggle {
        onSurfaceRequested: newName => root.surfaceRequested(newName)
    }

    PowerToggle {
        onCloseRequested: root.closeRequested()
    }
}
