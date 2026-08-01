import Quickshell
import QtQuick
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)
    signal closeRequested

    property real outerPaddingX: 22
    property real outerPaddingY: 8
    property real blockSpacing: 32

    implicitWidth: workspaces.implicitWidth + clock.implicitWidth + rightActions.implicitWidth + (blockSpacing * 2) + (outerPaddingX * 2)
    implicitHeight: Math.max(workspaces.implicitHeight, clock.implicitHeight, rightActions.implicitHeight) + (outerPaddingY * 2)

    Workspaces {
        id: workspaces
        anchors {
            left: parent.left
            leftMargin: root.outerPaddingX
            verticalCenter: parent.verticalCenter
        }
    }

    Clock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: root.surfaceRequested("calendar")
    }

    RightActions {
        id: rightActions
        anchors {
            right: parent.right
            rightMargin: root.outerPaddingX
            verticalCenter: parent.verticalCenter
        }
        onSurfaceRequested: newName => root.surfaceRequested(newName)
        onCloseRequested: root.closeRequested()
    }
}
