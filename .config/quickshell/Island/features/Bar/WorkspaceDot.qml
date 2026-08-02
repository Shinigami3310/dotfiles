import QtQuick
import "../../theme"
import "../../services"

Rectangle {
    id: root

    required property int index
    required property WorkspaceService handler

    readonly property int workspaceId: index + 1

    readonly property bool isActive: handler.isActive(workspaceId)
    readonly property bool isOccupied: handler.isOccupied(workspaceId)

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    width: Configs.workspaceDotSize
    height: Configs.workspaceDotSize
    radius: width / 2
    transformOrigin: Item.Center

    scale: pressed ? Configs.scalePressed : (hovered ? Configs.scaleHoverWorkspace : 1.0)
    color: isActive ? Theme.accent : (isOccupied ? Theme.text : "transparent")

    border {
        width: 1
        color: isActive ? Theme.accent : (isOccupied ? Theme.text : Theme.separator)
    }

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
        onClicked: handler.activateWorkspace(workspaceId)
    }
}
