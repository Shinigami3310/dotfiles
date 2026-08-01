import QtQuick
import "../../../services/integrations/"

Icon {
    source: "../../../assets/icons/Pomodoro.png"
    active: PomodoroService.isLoaded
    onClicked: PomodoroService.toggle()
}
