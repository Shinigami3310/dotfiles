import QtQuick
import "../config"

QtObject {
    id: factory

    function createNotification(input) {
        input = input || {};
        const imp = input.importance ?? Constants.importance.normal;
        const numericId = (typeof input.dbusId === "number" && input.dbusId > 0) ? input.dbusId : 0;
        const stringId = input.id ?? (numericId > 0 ? `dbus-${numericId}` : `n-${Date.now()}-${Math.floor(Math.random() * 10000)}`);

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

        return {
            id: stringId,
            dbusId: numericId,
            source: input.source ?? "Source not identified",
            summary: input.summary ?? "",
            text: input.text ?? "",
            icon: input.icon ?? "",
            time: notificationTime,
            importance: imp,
            origin: input.origin ?? Constants.origin.api,
            persistent: input.expireTimeout === 0 || imp === Constants.importance.critical,
            dismissible: true,
            read: false,
            expireTimeout: input.expireTimeout ?? -1,
            actions: input.actions || []          // ← ВОЗВРАЩАЕМ МАССИВ ДЕЙСТВИЙ
            ,
            rawNotification: input.rawNotification ?? null
        };
    }
}
