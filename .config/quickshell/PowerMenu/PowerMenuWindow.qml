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
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    function open() {
        visible = true;
        Qt.callLater(() => powerOffBtn.forceActiveFocus());
    }

    function close() {
        visible = false;
        Qt.quit();
    }

    function execAndClose(command) {
        Quickshell.execDetached(command);
        close();
    }

    BackgroundEffect.blurRegion: Region {
        item: contentRoot
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true

        readonly property var buttons: [rebootBtn, suspendBtn, powerOffBtn, hibernateBtn, lockBtn]
        property int lastIndex: 2

        function moveFocus(step) {
            const currentIndex = buttons.findIndex(btn => btn.activeFocus);
            const targetIndex = currentIndex !== -1 ? Math.max(0, Math.min(buttons.length - 1, currentIndex + step)) : lastIndex;

            buttons[targetIndex].forceActiveFocus();
        }

        Keys.onPressed: function (event) {
            switch (event.key) {
            case Qt.Key_Escape:
                root.close();
                event.accepted = true;
                break;
            case Qt.Key_Right:
                contentRoot.moveFocus(1);
                event.accepted = true;
                break;
            case Qt.Key_Left:
                contentRoot.moveFocus(-1);
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
            onTapped: root.close()
        }

        Item {
            id: card
            anchors.centerIn: parent
            width: buttonsRow.implicitWidth
            height: buttonsRow.implicitHeight

            Row {
                id: buttonsRow
                anchors.centerIn: parent
                spacing: 18

                ActionButton {
                    id: rebootBtn
                    source: "./icons/Reboot.png"
                    label: "Reboot"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 0
                    onActivated: root.execAndClose(["/usr/bin/systemctl", "reboot"])
                }

                ActionButton {
                    id: suspendBtn
                    source: "./icons/Suspend.png"
                    label: "Suspend"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 1
                    onActivated: root.execAndClose(["/usr/bin/systemctl", "suspend"])
                }

                ActionButton {
                    id: powerOffBtn
                    source: "./icons/Power.png"
                    label: "Power Off"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 2
                    onActivated: root.execAndClose(["/usr/bin/systemctl", "poweroff"])
                }

                ActionButton {
                    id: hibernateBtn
                    source: "./icons/Hibernate.png"
                    label: "Hibernate"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 3
                    onActivated: root.execAndClose(["/usr/bin/systemctl", "hibernate"])
                }

                ActionButton {
                    id: lockBtn
                    source: "./icons/Lock.png"
                    label: "Lock"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 4
                    onActivated: root.execAndClose(["/usr/bin/hyprlock"])
                }
            }
        }
    }
}
