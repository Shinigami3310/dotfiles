import QtQuick
import "../../services"
import "../../shared/theme"
import "../../core"
import "../../ui"

Row {
    id: root
    spacing: BarConfig.rightActionsSpacing

    signal surfaceRequested(string newName)
    signal closeRequested

    IconButton {
        iconName: "Eye.png"
        active: EyeReminderService.active
        onClicked: EyeReminderService.toggle()
    }

    IconButton {
        iconName: "Pomodoro.png"
        active: PomodoroService.active
        onClicked: PomodoroService.toggle()
    }

    IconButton {
        iconName: "Settings.png"
        onClicked: root.surfaceRequested(SurfaceNames.controlPanel)
    }

    IconButton {
        iconName: "Battery.png"
        onClicked: root.surfaceRequested(SurfaceNames.batteryProfile)
    }

    IconButton {
        id: powerIcon
        iconName: "Power.png"
        onClicked: {
            PowerService.openMenu();
            root.closeRequested();
        }
    }
}
