import QtQuick
import "../config"

QtObject {
    id: factory

    function createNotification(input) {
        input = input || {};
        var imp = input.importance || Constants.importance.normal;

        return {
            id: input.id || ("n-" + Date.now() + "-" + Math.floor(Math.random() * 10000)),
            source: input.source || "Source not identified",
            summary: input.summary || "",
            text: input.text || "",
            icon: input.icon || "",
            time: input.time || new Date(),
            importance: imp,
            origin: input.origin || Constants.origin.api,
            persistent: imp === Constants.importance.critical,
            dismissible: true,
            read: false
        };
    }
}
