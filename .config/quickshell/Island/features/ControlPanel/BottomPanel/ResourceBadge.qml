import QtQuick
import "../../../theme"

Item {
    id: root

    // Локальные константы из Config
    readonly property real resourceBadgeWidth: 54
    readonly property real resourceRowHeight: 48

    property string label: ""
    property string valueText: ""
    property real progress: 0.0

    implicitWidth: resourceBadgeWidth
    implicitHeight: resourceRowHeight

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: "transparent"
        border.color: ThemeColor.outline
        border.width: 1

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * Math.max(0, Math.min(1, root.progress))
            radius: 10
            color: ThemeColor.surface_container_highest
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
                color: ThemeColor.on_surface
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.valueText
                font.family: Theme.font
                font.pixelSize: 11
                font.bold: true
                color: ThemeColor.on_surface
            }
        }
    }
}
