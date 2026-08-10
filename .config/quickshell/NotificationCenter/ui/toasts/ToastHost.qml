import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../services/"
import "../../config"

PanelWindow {
    id: root

    property NotificationStore store
    property NotificationService service

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }
    margins {
        top: Settings.cornerMargin
        right: Settings.cornerMargin
    }

    implicitWidth: Settings.toastWidth
    implicitHeight: listView.contentHeight
    color: "transparent"

    ListView {
        id: listView
        anchors.fill: parent
        spacing: Settings.toastSpacing
        interactive: false
        model: root.store?.activeToastsModel ?? null

        delegate: ToastItem {
            width: ListView.view.width
            service: root.service
            notificationData: QtObject {
                readonly property string id: model.id ?? ""
                readonly property string source: model.source ?? ""
                readonly property string summary: model.summary ?? ""
                readonly property string text: model.text ?? ""
                readonly property string icon: model.icon ?? ""
                readonly property date time: model.time
                readonly property var importance: model.importance ?? ""
                readonly property string actionsJson: model.actionsJson ?? ""
            }
            onDismissRequested: root.service?.closeToastOnly(model.id, Constants.CloseReason.Dismissed)
            onActionInvoked: (actionKey) => root.service?.invokeAction(model.id, actionKey)
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutCubic }
                NumberAnimation { property: "x"; from: 120; to: 0; duration: 200; easing.type: Easing.OutCubic }
            }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutCubic }
        }
        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 200 }
                NumberAnimation { property: "x"; to: 120; duration: 200 }
            }
        }
    }
}
