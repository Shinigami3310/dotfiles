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
        Qt.callLater(function () {
            powerOffBtn.forceActiveFocus();
        });
    }

    function close() {
        visible = false;
        Qt.quit();
    }

    function runDetached(command) {
        Quickshell.execDetached(command);
    }

    function closeAndRun(command) {
        runDetached(command);
        close();
    }

    function reboot() {
        closeAndRun(["/usr/bin/systemctl", "reboot"]);
    }

    function suspend() {
        closeAndRun(["/usr/bin/systemctl", "suspend"]);
    }

    function powerOff() {
        closeAndRun(["/usr/bin/systemctl", "poweroff"]);
    }

    function hibernate() {
        closeAndRun(["/usr/bin/systemctl", "hibernate"]);
    }

    function lockScreen() {
        closeAndRun(["/usr/bin/hyprlock"]);
    }

    BackgroundEffect.blurRegion: Region {
        item: contentRoot
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true

        readonly property var buttons: [rebootBtn, suspendBtn, powerOffBtn, hibernateBtn, lockBtn]
        property int lastIndex: 2 // Индекс кнопки по умолчанию (Power Off)

        // Навигация вперед
        function focusNext() {
            var currentIndex = -1;
            for (var i = 0; i < buttons.length; i++) {
                if (buttons[i].activeFocus) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex !== -1) {
                // Если фокус уже на кнопке — сдвигаем право (без зацикливания)
                if (currentIndex < buttons.length - 1) {
                    buttons[currentIndex + 1].forceActiveFocus();
                }
            } else {
                // Если мышь увели и фокус исчез — возобновляем с места остановки
                buttons[lastIndex].forceActiveFocus();
            }
        }

        // Навигация назад
        function focusPrevious() {
            var currentIndex = -1;
            for (var i = 0; i < buttons.length; i++) {
                if (buttons[i].activeFocus) {
                    currentIndex = i;
                    break;
                }
            }

            if (currentIndex !== -1) {
                // Если фокус на кнопке — сдвигаем влево (без зацикливания)
                if (currentIndex > 0) {
                    buttons[currentIndex - 1].forceActiveFocus();
                }
            } else {
                // Если мышь увели и фокус исчез — возобновляем с места остановки
                buttons[lastIndex].forceActiveFocus();
            }
        }

        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Escape) {
                root.close();
                event.accepted = true;
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
                focusNext();
                event.accepted = true;
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
                focusPrevious();
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
            width: buttonsRow.implicitWidth
            height: buttonsRow.implicitHeight

            Row {
                id: buttonsRow
                anchors.centerIn: parent
                spacing: 18

                ActionButton {
                    id: rebootBtn
                    glyph: "↻"
                    label: "Reboot"
                    accent: "#FFCC80"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 0
                    onFocusCleared: contentRoot.forceActiveFocus()
                    onActivated: root.reboot()
                }

                ActionButton {
                    id: suspendBtn
                    glyph: "⏾"
                    label: "Suspend"
                    accent: "#90CAF9"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 1
                    onFocusCleared: contentRoot.forceActiveFocus()
                    onActivated: root.suspend()
                }

                ActionButton {
                    id: powerOffBtn
                    glyph: "⏻"
                    label: "Power Off"
                    accent: "#EF9A9A"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 2
                    onFocusCleared: contentRoot.forceActiveFocus()
                    onActivated: root.powerOff()
                }

                ActionButton {
                    id: hibernateBtn
                    glyph: "☾"
                    label: "Hibernate"
                    accent: "#CE93D8"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 3
                    onFocusCleared: contentRoot.forceActiveFocus()
                    onActivated: root.hibernate()
                }

                ActionButton {
                    id: lockBtn
                    glyph: "🔒"
                    label: "Lock"
                    accent: "#A5D6A7"
                    onActiveFocusChanged: if (activeFocus)
                        contentRoot.lastIndex = 4
                    onFocusCleared: contentRoot.forceActiveFocus()
                    onActivated: root.lockScreen()
                }
            }
        }
    }
}
