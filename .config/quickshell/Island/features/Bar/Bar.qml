import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)
    signal closeRequested

    readonly property int spacing: 32
    readonly property int paddingX: 24
    readonly property int paddingY: 8

    implicitWidth: workspaces.implicitWidth + clock.implicitWidth + rightActions.implicitWidth + (spacing * 2) + (paddingX * 2)
    implicitHeight: Math.max(workspaces.implicitHeight, clock.implicitHeight, rightActions.implicitHeight) + (paddingY * 2)

    Workspaces {
        id: workspaces
        anchors {
            left: parent.left
            leftMargin: root.paddingX
            verticalCenter: parent.verticalCenter
        }
    }

    Clock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: name => root.surfaceRequested(name)
    }

    RightActions {
        id: rightActions
        anchors {
            right: parent.right
            rightMargin: root.paddingX
            verticalCenter: parent.verticalCenter
        }

        onSurfaceRequested: name => root.surfaceRequested(name)
        onCloseRequested: root.closeRequested()
    }
}
