import QtQuick
import "../Singletons"

Item {
    id: root

    property date dateTime: new Date()

    property int firstWorkspaceId: 1
    property int dotCount: 5
    property int currentWorkspaceId: 1
    property var occupiedWorkspaceIds: []

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

    readonly property real leftWidth: workspaces.implicitWidth
    readonly property real centerWidth: centerClock.implicitWidth
    readonly property real rightWidth: actions.implicitWidth

    implicitWidth: Math.ceil(leftWidth + centerWidth + rightWidth + blockSpacing * 2 + outerPaddingX * 2)
    implicitHeight: Math.ceil(Math.max(workspaces.implicitHeight, centerClock.implicitHeight, actions.implicitHeight) + outerPaddingY * 2)
    width: implicitWidth
    height: implicitHeight

    Workspaces {
        id: workspaces
        anchors.left: parent.left
        anchors.leftMargin: root.outerPaddingX
        anchors.verticalCenter: parent.verticalCenter

        firstWorkspaceId: root.firstWorkspaceId
        dotCount: root.dotCount
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

        onEyeClicked: root.eyeClicked()
        onPomodoroClicked: root.pomodoroClicked()
        onSettingsClicked: root.settingsClicked()
        onBatteryClicked: root.batteryClicked()
        onPowerClicked: root.powerClicked()
    }
}
