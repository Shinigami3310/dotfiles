import QtQuick
import "../../services"
import "../../theme"

Row {
    id: root
    spacing: 8

    signal surfaceRequested(string newName)
    signal closeRequested

    Icon {
        iconName: "Eye.png"
        active: EyeReminderService.active
        onClicked: EyeReminderService.toggle()
    }

    Icon {
        iconName: "Pomodoro.png"
        active: PomodoroService.active
        onClicked: PomodoroService.toggle()
    }

    Icon {
        iconName: "Settings.png"
        onClicked: root.surfaceRequested("controlPanel")
    }

    Icon {
        iconName: "Battery.png"
        onClicked: root.surfaceRequested("batteryProfile")
    }

    Icon {
        id: powerIcon
        iconName: "Power.png"
        onClicked: {
            PowerService.openMenu();
            root.closeRequested();
        }
    }
}
