import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../config"

PanelWindow {
    id: root

    property var store
    property var service

    readonly property bool hasHistory: root.store && root.store.historyModel.count > 0

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        top: Settings.cornerMargin
        right: Settings.cornerMargin
    }

    implicitWidth: Settings.centerWidth
    implicitHeight: mainRect.implicitHeight
    color: "transparent"
    visible: false

    onVisibleChanged: {
        if (visible) {
            mainRect.forceActiveFocus();
        }
    }

    Shortcut {
        sequence: "Escape"
        context: Qt.WindowShortcut
        enabled: root.visible
        onActivated: root.visible = false
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton)
                root.visible = false;
        }

        Rectangle {
            id: mainRect
            width: parent.width
            implicitHeight: mainLayout.implicitHeight + 24
            color: Colors.panel
            radius: 14
            border.width: 1.5
            border.color: Colors.borderNormal
            focus: true

            Keys.onEscapePressed: root.visible = false

            ColumnLayout {
                id: mainLayout
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 12
                }
                spacing: root.hasHistory ? 10 : 0

                CenterHeader {
                    Layout.fillWidth: true
                    service: root.service
                    onClearAllRequested: if (root.store)
                        root.store.clear()
                }

                NotificationList {
                    Layout.fillWidth: true
                    visible: root.hasHistory
                    store: root.store
                    onDismissRequested: function (notificationId) {
                        if (root.store)
                            root.store.removeById(notificationId);
                    }
                }
            }
        }
    }
}
