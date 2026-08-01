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
        font {
            family: Theme.font
            pixelSize: 18
            weight: Font.DemiBold
        }
        color: Theme.textMuted
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
