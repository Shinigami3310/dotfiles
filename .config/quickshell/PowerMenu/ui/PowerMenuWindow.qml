import QtQuick
import "../shared/theme"
import "../theme"

Item {
    id: root
    focus: true

    signal closeRequested
    signal actionRequested(var command)

    readonly property var buttons: [rebootBtn, suspendBtn, powerOffBtn, hibernateBtn, lockBtn]
    property int lastIndex: 2

    function open() {
        Qt.callLater(() => powerOffBtn.forceActiveFocus());
    }

    function moveFocus(step) {
        const currentIndex = buttons.findIndex(btn => btn.activeFocus);
        const targetIndex = currentIndex !== -1 ? Math.max(0, Math.min(buttons.length - 1, currentIndex + step)) : lastIndex;
        buttons[targetIndex].forceActiveFocus();
    }

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_Escape:
            root.closeRequested();
            event.accepted = true;
            break;
        case Qt.Key_Right:
            root.moveFocus(1);
            event.accepted = true;
            break;
        case Qt.Key_Left:
            root.moveFocus(-1);
            event.accepted = true;
            break;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#22000000"
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.closeRequested()
    }

    Row {
        id: buttonsRow
        anchors.centerIn: parent
        spacing: 18 * Configs.uiScale

        ActionButton {
            id: rebootBtn
            source: "../icons/Reboot.png"
            label: "Reboot"
            onActiveFocusChanged: if (activeFocus)
                root.lastIndex = 0
            onActivated: root.actionRequested(["/usr/bin/systemctl", "reboot"])
        }

        ActionButton {
            id: suspendBtn
            source: "../icons/Suspend.png"
            label: "Suspend"
            onActiveFocusChanged: if (activeFocus)
                root.lastIndex = 1
            onActivated: root.actionRequested(["/usr/bin/systemctl", "suspend"])
        }

        ActionButton {
            id: powerOffBtn
            source: "../icons/Power.png"
            label: "Power Off"
            onActiveFocusChanged: if (activeFocus)
                root.lastIndex = 2
            onActivated: root.actionRequested(["/usr/bin/systemctl", "poweroff"])
        }

        ActionButton {
            id: hibernateBtn
            source: "../icons/Hibernate.png"
            label: "Hibernate"
            onActiveFocusChanged: if (activeFocus)
                root.lastIndex = 3
            onActivated: root.actionRequested(["/usr/bin/systemctl", "hibernate"])
        }

        ActionButton {
            id: lockBtn
            source: "../icons/Lock.png"
            label: "Lock"
            onActiveFocusChanged: if (activeFocus)
                root.lastIndex = 4
            onActivated: root.actionRequested(["/usr/bin/hyprlock"])
        }
    }
}