pragma ComponentBehavior: Bound
import QtQuick
import "../../theme"
import "../../services"

Row {
    id: root

    spacing: Configs.workspaceGap

    WorkspaceService {
        id: handler
    }

    Repeater {
        model: Configs.workspaceCount

        delegate: Rectangle {
            id: dot
            required property int index

            readonly property int workspaceId: index + 1
            readonly property bool isActive: handler.isActive(workspaceId)
            readonly property bool isOccupied: handler.isOccupied(workspaceId)

            width: Configs.workspaceDotSize
            height: Configs.workspaceDotSize
            radius: width / 2

            scale: mouseArea.pressed ? 0.9 : (mouseArea.containsMouse ? 1.2 : 1.0)
            transformOrigin: Item.Center

            color: isActive ? Theme.accent : (isOccupied ? Theme.text : "transparent")
            border.width: 1
            border.color: isActive ? Theme.accent : (isOccupied ? Theme.text : Theme.separator)

            Behavior on scale {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: handler.activateWorkspace(dot.workspaceId)
            }
        }
    }
}
