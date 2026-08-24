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
    // Статичная высота контейнера тостов предотвращает лаги при частых удалених/добавлениях
    implicitHeight: ToastsConfig.maxHeight ?? 600
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
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.durationStandard; easing.type: Motion.curveOpacityIn }
                NumberAnimation { property: "x"; from: 120; to: 0; duration: Motion.durationStandard; easing.type: Motion.curveOpacityIn }
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
