import QtQuick
import "../config"

QtObject {
    id: store

    readonly property ListModel historyModel: ListModel {}
    readonly property ListModel activeToastsModel: ListModel {}

    function add(notification) {
        const prepared = _prepareNotification(notification);
        const existingIdx = _findIndexById(historyModel, prepared.id);
        if (existingIdx !== -1) {
            historyModel.set(existingIdx, prepared);
        } else {
            historyModel.insert(0, prepared);
            if (historyModel.count > Settings.maxHistoryItems) {
                historyModel.remove(historyModel.count - 1);
            }
        }
    }

    function addToast(notification) {
        const prepared = _prepareNotification(notification);
        const existingIdx = _findIndexById(activeToastsModel, prepared.id);
        if (existingIdx !== -1) {
            activeToastsModel.set(existingIdx, prepared);
        } else {
            activeToastsModel.insert(0, prepared);
            if (activeToastsModel.count > Settings.toastMaxVisible) {
                activeToastsModel.remove(activeToastsModel.count - 1);
            }
        }
    }

    function removeById(id) {
        _removeFromModel(historyModel, id);
        _removeFromModel(activeToastsModel, id);
    }

    function removeToastById(id) {
        _removeFromModel(activeToastsModel, id);
    }

    function findById(id) {
        const idx = _findIndexById(historyModel, id);
        return idx !== -1 ? historyModel.get(idx) : null;
    }

    function clear() {
        historyModel.clear();
        activeToastsModel.clear();
    }

    function _prepareNotification(notif) {
        const actionsJson = JSON.stringify(notif.actions ?? []);
        return {
            id: notif.id,
            dbusId: notif.dbusId,
            source: notif.source,
            summary: notif.summary,
            text: notif.text,
            icon: notif.icon,
            time: notif.time,
            importance: notif.importance,
            origin: notif.origin,
            persistent: notif.persistent,
            dismissible: notif.dismissible,
            read: notif.read,
            expireTimeout: notif.expireTimeout,
            actionsJson: actionsJson,
            rawNotification: notif.rawNotification
        };
    }

    function _findIndexById(listModel, id) {
        for (let i = 0; i < listModel.count; i++) {
            if (listModel.get(i).id === id)
                return i;
        }
        return -1;
    }

    function _removeFromModel(listModel, id) {
        const idx = _findIndexById(listModel, id);
        if (idx !== -1)
            listModel.remove(idx);
    }
}
