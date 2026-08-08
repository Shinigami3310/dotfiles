import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)
    signal closeRequested

    implicitWidth: workspaces.implicitWidth + clock.implicitWidth + rightActions.implicitWidth + (BarConfig.spacing * 2) + (BarConfig.paddingX * 2)
    implicitHeight: Math.max(workspaces.implicitHeight, clock.implicitHeight, rightActions.implicitHeight) + (BarConfig.paddingY * 2)

    Workspaces {
        id: workspaces
        anchors {
            left: parent.left
            leftMargin: BarConfig.paddingX
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
            rightMargin: BarConfig.paddingX
            verticalCenter: parent.verticalCenter
        }

        onSurfaceRequested: name => root.surfaceRequested(name)
        onCloseRequested: root.closeRequested()
    }
}
