import QtQuick
import "../core"
import "../modules/bar"
import "../Singletons"

SurfaceBase {
    id: root

    surfaceName: "bar"
    persistent: false
    wantsKeyboardFocus: true
    escapePolicy: escapeBack
    canGoBack: true

    property real outerPaddingX: 22
    property real outerPaddingY: 8
    property real blockSpacing: 14

    Item {
        id: leftBlock
        anchors.left: parent.left
        anchors.leftMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: workspaces.implicitWidth
        implicitHeight: workspaces.implicitHeight

        Workspaces {
            id: workspaces
        }
    }

    Item {
        id: centerBlock
        anchors.centerIn: parent

        implicitWidth: clock.implicitWidth
        implicitHeight: clock.implicitHeight

        Clock {
            id: clock
            onSurfaceRequested: root.surfaceRequested(newName, payload)
        }
    }

    Item {
        id: rightBlock
        anchors.right: parent.right
        anchors.rightMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: leftBlock.implicitWidth
        implicitHeight: rightActions.implicitHeight

        RightActions {
            id: rightActions
            onSurfaceRequested: root.surfaceRequested(newName, payload)
        }
    }

    implicitWidth: leftBlock.implicitWidth + centerBlock.implicitWidth + rightBlock.implicitWidth + blockSpacing * 2 + outerPaddingX * 2
    implicitHeight: Math.max(leftBlock.implicitHeight, centerBlock.implicitHeight, rightBlock.implicitHeight) + outerPaddingY * 2

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: root.backRequested()
    }
}
