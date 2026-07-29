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

        let importance = Constants.importance.normal;
        if (notification.urgency === NotificationUrgency.Critical) {
            importance = Constants.importance.critical;
        } else if (notification.urgency === NotificationUrgency.Low) {
            importance = Constants.importance.low;
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
            } else {
                iconSource = undefined;
            }
        }

        const result = service.notify({
            dbusId: notification.id,
            replacesId: notification.replacesId ?? 0,
            source: notification.appName ?? "Source not identified",
            summary: notification.summary ?? "",
            text: notification.body ?? notification.summary ?? "",
            icon: iconSource,
            importance: importance,
            origin: Constants.origin.dbus,
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
            origin: Constants.origin.api
        });
        return service.notify(request);
    }
}
