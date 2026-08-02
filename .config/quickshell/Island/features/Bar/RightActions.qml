import QtQuick
import "../../services"
import "../../services/integrations"
import "../../theme"

Row {
    id: root
    spacing: Configs.barActionsSpacing

    signal surfaceRequested(string newName)
    signal closeRequested

    Icon {
        source: "../../assets/icons/Eye.png"
        active: EyeReminderService.active
        onClicked: EyeReminderService.toggle()
    }

    Icon {
        source: "../../assets/icons/Pomodoro.png"
        active: PomodoroService.active
        onClicked: PomodoroService.toggle()
    }

    Icon {
        source: "../../assets/icons/Settings.png"
        onClicked: root.surfaceRequested("controlPanel")
    }

    Icon {
        source: "../../assets/icons/Battery.png"
        onClicked: root.surfaceRequested("batteryProfile")
    }

    Icon {
        id: powerIcon
        source: "../../assets/icons/Power.png"

        PowerService {
            id: powerService
        }

        onClicked: {
            powerService.openMenu();
            root.closeRequested();
        }
    }
}
