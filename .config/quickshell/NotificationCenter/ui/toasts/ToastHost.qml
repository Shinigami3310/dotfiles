import QtQuick
import Quickshell
import Quickshell.Wayland
import "../toasts"
import "../common"
import "../../config"
import "../../services"
import "../../shared/theme"

PanelWindow {
    id: root

    property NotificationStore store
    property NotificationService service

    readonly property int toastCount: root.store?.activeToastsModel?.count ?? 0

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }
    margins {
        top: ToastsConfig.cornerMargin
        right: ToastsConfig.cornerMargin
    }

    implicitWidth: ToastsConfig.width
    implicitHeight: root.toastCount > 0
    ? Math.min(listView.contentHeight + ToastsConfig.spacing, ToastsConfig.maxHeight)
    : 0

    color: "transparent"

    ListView {
        id: listView
        anchors.fill: parent
        spacing: ToastsConfig.spacing
        interactive: false
        model: root.store?.activeToastsModel ?? null

        delegate: NotificationCard {
            width: ListView.view.width
            service: root.service
            showHoverPause: true
            notificationData: model
            onDismissRequested: root.service?.closeToastOnly(model.id, Constants.CloseReason.Dismissed)
            onActionInvoked: (actionKey) => root.service?.invokeAction(model.id, actionKey)
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.durationSlow; easing.type: Motion.curveOpacityIn }
                NumberAnimation { property: "x"; from: 120; to: 0; duration: Motion.durationSlow; easing.type: Motion.curveOpacityIn }
            }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: Motion.durationSlow; easing.type: Motion.curveMoveIn }
        }
        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: Motion.durationSlow }
                NumberAnimation { property: "x"; to: 120; duration: Motion.durationSlow }
            }
        }
        removeDisplaced: Transition {
            NumberAnimation { properties: "y"; duration: Motion.durationSlow; easing.type: Motion.curveMoveIn }
        }
    }
}
