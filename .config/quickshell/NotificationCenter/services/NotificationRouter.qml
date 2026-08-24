import QtQuick
import Quickshell.Services.Notifications
import "../config"

QtObject {
    id: router

    property NotificationService service

    function fromDbus(notification) {
        if (!service || !notification) {
            return null;
        }

        let importance = Constants.Importance.Normal;
        if (notification.urgency === NotificationUrgency.Critical) {
            importance = Constants.Importance.Critical;
        } else if (notification.urgency === NotificationUrgency.Low) {
            importance = Constants.Importance.Low;
        }

        const formattedActions = [];
        if (notification.actions?.length > 0) {
            for (const act of notification.actions) {
                if (!act)
                    continue;
                const key = act.identifier ?? act.id ?? act.key ?? "";
                const text = act.text ?? act.label ?? key;
                formattedActions.push({
                    key,
                    text
                });
            }
        }

        const rawIcon = notification.appIcon || notification.image || "";
        let iconSource = "";
        if (rawIcon !== "") {
            if (rawIcon.startsWith("/") || rawIcon.startsWith("file://") || rawIcon.startsWith("http://") || rawIcon.startsWith("https://") || rawIcon.startsWith("image://")) {
                iconSource = rawIcon;
            }
        }

        const result = service.notify({
            dbusId: notification.id,
            replacesId: notification.replacesId ?? 0,
            source: notification.appName ?? Constants.sourceUnknown,
            summary: notification.summary ?? "",
            text: notification.body ?? notification.summary ?? "",
            icon: iconSource,
            importance: importance,
            origin: Constants.Origin.Dbus,
            expireTimeout: notification.expireTimeout,
            actions: formattedActions,
            rawNotification: notification
        });
        return result;
    }

    function fromApi(payload) {
        if (!service)
            return null;
        const request = Object.assign({}, payload ?? {}, {
            origin: Constants.Origin.Api
        });
        return service.notify(request);
    }
}
