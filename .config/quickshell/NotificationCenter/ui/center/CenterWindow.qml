import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../config"
import "../../services/"

PanelWindow {
    id: root

    property NotificationStore store
    property NotificationService service

    readonly property bool hasHistory: store?.historyModel.count > 0

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

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
        if (visible)
            mainRect.forceActiveFocus();
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
        onClicked: mouse => {
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
                spacing: hasHistory ? 10 : 0

                CenterHeader {
                    Layout.fillWidth: true
                    service: root.service
                    onClearAllRequested: root.store?.clear()
                }

                NotificationList {
                    Layout.fillWidth: true
                    visible: hasHistory
                    store: root.store
                    service: root.service
                    onDismissRequested: id => root.service?.close(id, Constants.closeReason.dismissed)
                }
            }
        }
    }
}
