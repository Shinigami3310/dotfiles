import QtQuick
import Quickshell
import "../core"
import "../Singletons"
import "../modules/bar"

SurfaceBase {
    id: root

    surfaceName: "bar"

    property real outerPaddingX: 18
    property real outerPaddingY: 8
    property real blockSpacing: 14

    signal controlPanelRequested
    signal batteryProfileRequested
    signal powerRequested
    implicitWidth: leftBlock.implicitWidth + centerBlock.implicitWidth + rightBlock.implicitWidth + blockSpacing * 2 + outerPaddingX * 2
    implicitHeight: Math.max(leftBlock.implicitHeight, centerBlock.implicitHeight, rightBlock.implicitHeight) + outerPaddingY * 2
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
            onClicked: root.surfaceRequested("calendar", null)
        }
    }

    Item {
        id: rightBlock
        anchors.right: parent.right
        anchors.rightMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        implicitWidth: rightActions.implicitWidth
        implicitHeight: rightActions.implicitHeight
        RightActions {
            id: rightActions
            onSettingsClicked: root.controlPanelRequested()
            onBatteryClicked: root.batteryProfileRequested()
            onPowerClicked: root.powerRequested()
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: root.backRequested()
    }
}
