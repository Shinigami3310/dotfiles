import QtQuick
import "../../theme"

Item {
    id: root

    property alias text: label.text
    signal clicked

    width: 22
    height: 22

    Text {
        id: label
        anchors.centerIn: parent
        font.family: Theme.font
        font.pixelSize: 18
        font.weight: Font.DemiBold
        color: Theme.textMuted
        antialiasing: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: root.clicked()
    }
}
