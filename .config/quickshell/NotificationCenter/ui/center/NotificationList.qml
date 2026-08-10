import QtQuick
import "../../config"

import "../../services/"

ListView {
    id: root

    property NotificationStore store
    property NotificationService service
    signal dismissRequested(string notificationId)

    width: parent?.width ?? Settings.centerWidth
    clip: true
    model: root.store?.historyModel ?? null
    spacing: 8
    implicitHeight: Math.min(contentHeight, Settings.listMaxHeight)

    delegate: NotificationListItem {
        width: root.width
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
        onDismissRequested: root.dismissRequested(model.id)
        onActionInvoked: (actionKey) => root.service?.invokeAction(model.id, actionKey)
    }

    displaced: Transition {
        NumberAnimation { properties: "y"; duration: 200 }
    }
}
