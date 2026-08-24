import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../center"
import "../../config"
import "../../services"
import "../../shared/theme"

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
        top: CenterConfig.cornerMargin
        right: CenterConfig.cornerMargin
    }

    implicitWidth: CenterConfig.width
    implicitHeight: CenterConfig.listMaxHeight + CenterConfig.padding * 2
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

    Rectangle {
        id: mainRect
        width: parent.width
        implicitHeight: mainLayout.implicitHeight + CenterConfig.padding * 2
        color: Colors.panel
        radius: CenterConfig.radius
        border.width: CenterConfig.borderWidth
        border.color: Colors.borderNormal
        focus: true

        Behavior on implicitHeight {
            NumberAnimation {
                duration: Motion.durationSlow
                easing.type: Easing.OutQuad
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: root.visible = false
        }

        ColumnLayout {
            id: mainLayout
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: CenterConfig.padding
            }
            spacing: hasHistory ? CenterConfig.columnSpacing : 0

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
                onDismissRequested: id => root.service?.close(id, Constants.CloseReason.Dismissed)
            }
        }
    }
}
