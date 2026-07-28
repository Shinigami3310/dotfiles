import QtQuick
import "../../config"

ListView {
    id: root

    property var store
    signal dismissRequested(string notificationId)

    width: parent ? parent.width : 340
    clip: true

    model: root.store ? root.store.historyModel : null
    spacing: 8

    implicitHeight: Math.min(contentHeight, 340)

    delegate: NotificationListItem {
        required property var model

        width: root.width

        notification: ({
                id: model.id,
                source: model.source,
                summary: model.summary,
                text: model.text,
                icon: model.icon,
                time: model.time,
                importance: model.importance
            })
        onDismissRequested: root.dismissRequested(model.id)
    }

    displaced: Transition {
        NumberAnimation {
            properties: "y"
            duration: 200
        }
    }
}
