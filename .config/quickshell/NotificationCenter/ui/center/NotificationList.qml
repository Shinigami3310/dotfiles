import QtQuick
import "../center"
import "../common"
import "../../config"
import "../../services"
import "../../shared/theme"

ListView {
    id: root

    property NotificationStore store
    property NotificationService service
    signal dismissRequested(string notificationId)

    width: parent?.width ?? CenterConfig.width
    clip: true
    model: root.store?.historyModel ?? null
    spacing: CenterConfig.listSpacing
    implicitHeight: Math.min(contentHeight, CenterConfig.listMaxHeight)

Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.durationSlow
            easing.type: Easing.OutQuad
        }
    }

    delegate: NotificationCard {
        width: root.width
        compact: true
        notificationData: model
        onDismissRequested: root.dismissRequested(model.id)
        onActionInvoked: (actionKey) => root.service?.invokeAction(model.id, actionKey)
    }

    remove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: Motion.durationSlow }
    }

    removeDisplaced: Transition {
        NumberAnimation { properties: "y"; duration: Motion.durationSlow; easing.type: Easing.OutQuad }
    }

    displaced: Transition {
        NumberAnimation { properties: "y"; duration: Motion.durationSlow; easing.type: Easing.OutQuad }
    }
}
