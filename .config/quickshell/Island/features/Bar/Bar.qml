import Quickshell
import QtQuick
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)
    signal closeRequested

    implicitWidth: workspaces.implicitWidth + clock.implicitWidth + rightActions.implicitWidth + (Configs.barBlockSpacing * 2) + (Configs.barPaddingX * 2)
    implicitHeight: Math.max(workspaces.implicitHeight, clock.implicitHeight, rightActions.implicitHeight) + (Configs.barPaddingY * 2)

    Workspaces {
        id: workspaces
        anchors {
            left: parent.left
            leftMargin: Configs.barPaddingX
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
            rightMargin: Configs.barPaddingX
            verticalCenter: parent.verticalCenter
        }
        onSurfaceRequested: name => root.surfaceRequested(name)
        onCloseRequested: root.closeRequested()
    }
}
