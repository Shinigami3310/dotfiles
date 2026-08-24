import QtQuick
import "../../../shared/theme"
import "../"

Item {
    id: root

    property string label: ""
    property string valueText: ""
    property real progress: 0.0

    implicitWidth: ControlPanelConfig.badgeWidth
    implicitHeight: ControlPanelConfig.badgeHeight

    Rectangle {
        anchors.fill: parent
        radius: ControlPanelConfig.badgeRadius
        color: ThemeColor.transparent
        border.color: ThemeColor.outline
        border.width: 1
        clip: true

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * Math.max(0, Math.min(1, root.progress))
            radius: ControlPanelConfig.badgeRadius
            color: ThemeColor.surface_container_highest
            opacity: 0.6

            Behavior on height {
                NumberAnimation {
                    duration: Motion.durationExpand
                    easing.type: Motion.curveResize
                }
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                font.family: Theme.font
                font.pixelSize: ControlPanelConfig.badgeLabelSize
                color: ThemeColor.on_surface
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.valueText
                font.family: Theme.font
                font.pixelSize: ControlPanelConfig.badgeValueSize
                font.bold: true
                color: ThemeColor.on_surface
            }
        }
    }
}
