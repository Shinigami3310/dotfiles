import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    focusable: true
    color: "#66000000"
    surfaceFormat.opaque: false

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    function open() {
        visible = true;
        Qt.callLater(function () {
            contentRoot.forceActiveFocus();
        });
    }

    function close() {
        visible = false;
    }

    function toggle() {
        if (visible) {
            close();
        } else {
            open();
        }
    }

    function runDetached(command) {
        Quickshell.execDetached(command);
    }

    function closeAndRun(command) {
        close();
        Qt.callLater(function () {
            runDetached(command);
        });
    }

    function reboot() {
        closeAndRun(["systemctl", "reboot"]);
    }

    function suspend() {
        closeAndRun(["systemctl", "suspend"]);
    }

    function powerOff() {
        closeAndRun(["systemctl", "poweroff"]);
    }

    function hibernate() {
        closeAndRun(["systemctl", "hibernate"]);
    }

    function lockScreen() {
        closeAndRun(["loginctl", "lock-session", "self"]);
    }

    IpcHandler {
        target: "powermenu"

        function open(): void {
            root.open();
        }

        function close(): void {
            root.close();
        }

        function toggle(): void {
            root.toggle();
        }
    }

    BackgroundEffect.blurRegion: Region {
        item: root.contentItem
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true

        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Escape) {
                root.close();
                event.accepted = true;
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#22000000"
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: root.close()
        }

        Item {
            id: card
            anchors.centerIn: parent
            width: buttonsRow.width
            height: 124

            Column {
                anchors.centerIn: parent
                spacing: 14

                Row {
                    id: buttonsRow
                    spacing: 18

                    ActionButton {
                        glyph: "↻"
                        label: "Reboot"
                        accent: "#FFCC80"
                        onActivated: root.reboot()
                    }

                    ActionButton {
                        glyph: "⏾"
                        label: "Suspend"
                        accent: "#90CAF9"
                        onActivated: root.suspend()
                    }

                    ActionButton {
                        glyph: "⏻"
                        label: "Power Off"
                        accent: "#EF9A9A"
                        onActivated: root.powerOff()
                    }

                    ActionButton {
                        glyph: "☾"
                        label: "Hibernate"
                        accent: "#CE93D8"
                        onActivated: root.hibernate()
                    }

                    ActionButton {
                        glyph: "🔒"
                        label: "Lock"
                        accent: "#A5D6A7"
                        onActivated: root.lockScreen()
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(function () {
                contentRoot.forceActiveFocus();
            });
        }
    }
}
