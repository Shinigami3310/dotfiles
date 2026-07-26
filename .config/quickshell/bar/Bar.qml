import "../Singletons"
import "../core"
import Quickshell

import QtQuick

SurfaceBase {
    id: root
    wantsKeyboardFocus: true   // уже есть в SurfaceBase, но явно не помешает
    canGoBack: true            // включает обработку Esc → backRequested
    persistent: false
    // ===== Уникальные свойства Bar =====
    property date dateTime: new Date()

    property bool eyeActive: false
    property bool pomodoroActive: false
    property bool settingsActive: false
    property bool batteryActive: false
    property bool powerActive: false

    property real outerPaddingX: 18
    property real outerPaddingY: 8
    property real blockSpacing: 14

    signal eyeClicked
    signal pomodoroClicked
    signal settingsClicked
    signal batteryClicked
    signal powerClicked
    signal workspaceActivated(int workspaceId)

    readonly property real leftWidth: workspaces.implicitWidth
    readonly property real centerWidth: centerClock.implicitWidth
    readonly property real rightWidth: actions.implicitWidth

    implicitWidth: leftWidth + centerWidth + rightWidth + blockSpacing * 2 + outerPaddingX * 2
    implicitHeight: Math.max(workspaces.implicitHeight, centerClock.implicitHeight, actions.implicitHeight) + outerPaddingY * 2

    Workspaces {
        id: workspaces
        anchors.left: parent.left
        anchors.leftMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        onWorkspaceActivated: root.workspaceActivated(workspaceId)
    }

    Clock {
        id: centerClock
        anchors.centerIn: parent
        dateTime: root.dateTime
    }

    RightActions {
        id: actions
        anchors.right: parent.right
        anchors.rightMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        eyeActive: root.eyeActive
        pomodoroActive: root.pomodoroActive
        settingsActive: root.settingsActive
        batteryActive: root.batteryActive
        powerActive: root.powerActive

        onEyeClicked: root.eyeClicked()
        onPomodoroClicked: root.pomodoroClicked()
        onSettingsClicked: root.settingsClicked()
        onBatteryClicked: root.batteryClicked()
        onPowerClicked: root.powerClicked()
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: {
            root.backRequested();
        }
    }
}
