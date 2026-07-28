import QtQuick
import Quickshell.Services.Notifications
import "../config"

QtObject {
    id: router

    property var service

    function fromDbus(notification) {
        if (!service || !notification)
            return null;

        var importance = Constants.importance.normal;
        if (notification.urgency === NotificationUrgency.Critical) {
            importance = Constants.importance.critical;
        } else if (notification.urgency === NotificationUrgency.Low) {
            importance = Constants.importance.low;
        }

        return service.notify({
            source: notification.appName || "Source not identified",
            summary: notification.summary || "",
            text: notification.body || notification.summary || "",
            icon: notification.appIcon || notification.image || "",
            importance: importance,
            origin: Constants.origin.dbus
        });
    }

    function fromApi(payload) {
        if (!service)
            return null;
        payload = payload || {};
        var request = Object.assign({}, payload, {
            origin: Constants.origin.api
        });
        return service.notify(request);
    }
}
