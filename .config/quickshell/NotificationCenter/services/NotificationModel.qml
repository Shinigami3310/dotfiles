import QtQuick
import "../config"

QtObject {
    id: factory

    property int _idCounter: 0

    function _nextId() {
        return `n-${Date.now()}-${_idCounter++}`;
    }

    function createNotification(input) {
        input = input || {};
        const imp = input.importance ?? Constants.Importance.Normal;
        const numericId = (typeof input.dbusId === "number" && input.dbusId > 0) ? input.dbusId : 0;
        const stringId = input.id ?? (numericId > 0 ? `dbus-${numericId}` : _nextId());

        let notificationTime;
        if (input.time instanceof Date) {
            notificationTime = input.time;
        } else if (typeof input.time === "number") {
            notificationTime = new Date(input.time);
        } else if (typeof input.time === "string") {
            const parsed = Date.parse(input.time);
            notificationTime = isNaN(parsed) ? new Date() : new Date(parsed);
        } else {
            notificationTime = new Date();
        }

        const actions = Array.isArray(input.actions) ? input.actions : [];

        return {
            id: stringId,
            dbusId: numericId,
            source: input.source ?? Constants.sourceUnknown,
            summary: input.summary ?? "",
            text: input.text ?? "",
            icon: input.icon ?? "",
            time: notificationTime,
            importance: imp,
            origin: input.origin ?? Constants.Origin.Api,
            persistent: input.expireTimeout === 0 || imp === Constants.Importance.Critical,
            expireTimeout: input.expireTimeout ?? -1,
            actions: actions,
            rawNotification: input.rawNotification ?? null
        };
    }
}