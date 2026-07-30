import QtQuick

import "../../theme"

Item {
    id: root

    property string label: ""
    property string valueText: ""
    property real progress: 0.0

    implicitWidth: 54
    implicitHeight: 48

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: Theme.surface1
        border.color: Theme.panelBorder
        border.width: 1

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * Math.max(0, Math.min(1, root.progress))
            radius: 10
            color: Theme.surface2
            opacity: 0.6
        }

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                font.family: Theme.font
                font.pixelSize: 10
                color: Theme.textMuted
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.valueText
                font.family: Theme.font
                font.pixelSize: 11
                font.bold: true
                color: Theme.text
            }
        }
    }
}
