import QtQuick
import "../../theme"
import "../../services/"

Rectangle {
    id: root

    required property int index

    readonly property int workspaceId: index + 1

    readonly property bool isActive: WorkspaceService.isActive(workspaceId)
    readonly property bool isOccupied: WorkspaceService.isOccupied(workspaceId)

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    width: 16
    height: 16
    radius: width / 2

    scale: pressed ? Configs.scalePressed : (hovered ? 1.2 : 1.0)
    color: isActive ? ThemeColor.primary : (isOccupied ? ThemeColor.on_surface : "transparent")

    border {
        width: 2
        color: isActive ? ThemeColor.primary : ThemeColor.on_surface
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

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton
        onTapped: WorkspaceService.activateWorkspace(workspaceId)
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
}
