import QtQuick
import "../../services/integrations/"

Icon {
    source: "../../assets/icons/pomodoro.png"
    active: PomodoroService.active
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: PomodoroService.toggle()
    }
}
