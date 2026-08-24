import QtQuick
import "../config"
import "../ui/toasts"
import "../ui/center"

QtObject {
    id: store

    readonly property ListModel historyModel: ListModel {}
    readonly property ListModel activeToastsModel: ListModel {}

    // Живые DBus-объекты хранятся отдельно, чтобы не держать их в ListModel
    // (утечка памяти при большом количестве уведомлений).
    property var _rawNotifications: ({})

    function add(notification) {
        if (!notification)
            return;

        const prepared = _sanitize(notification);
        if (notification.rawNotification)
            _rawNotifications[prepared.id] = notification.rawNotification;

        const existingIdx = _findIndexById(historyModel, prepared.id);
        if (existingIdx !== -1) {
            historyModel.set(existingIdx, prepared);
        } else {
            historyModel.insert(0, prepared);
            if (historyModel.count > CenterConfig.maxHistoryItems) {
                const removed = historyModel.get(historyModel.count - 1);
                historyModel.remove(historyModel.count - 1);
                delete _rawNotifications[removed.id];
            }
        }
    }

    function addToast(notification) {
        if (!notification)
            return;

        const prepared = _sanitize(notification);
        const existingIdx = _findIndexById(activeToastsModel, prepared.id);
        if (existingIdx !== -1) {
            activeToastsModel.set(existingIdx, prepared);
        } else {
            activeToastsModel.insert(0, prepared);
            if (activeToastsModel.count > ToastsConfig.maxVisible) {
                activeToastsModel.remove(activeToastsModel.count - 1);
            }
        }
    }

    function removeById(id) {
        delete _rawNotifications[id];
        _removeFromModel(historyModel, id);
        _removeFromModel(activeToastsModel, id);
    }

    function removeToastById(id) {
        _removeFromModel(activeToastsModel, id);
    }

    function findById(id) {
        const idx = _findIndexById(historyModel, id);
        if (idx === -1)
            return null;
        return Object.assign({}, historyModel.get(idx), {
            rawNotification: _rawNotifications[id] ?? null
        });
    }

    function clear() {
        historyModel.clear();
        activeToastsModel.clear();
        _rawNotifications = {};
    }

    // Копия без живых DBus-объектов: в ListModel держать raw нельзя (утечка).
    function _sanitize(notif) {
        const snap = Object.assign({}, notif, {
            actions: notif.actions ?? [],
            actionsJson: JSON.stringify(notif.actions ?? [])
        });
        delete snap.rawNotification;
        return snap;
    }

    function _findIndexById(listModel, id) {
        if (!listModel || !id)
            return -1;
        for (let i = 0; i < listModel.count; i++) {
            if (listModel.get(i).id === id)
                return i;
        }
        return -1;
    }

    function _removeFromModel(listModel, id) {
        if (!listModel || !id)
            return;
        const idx = _findIndexById(listModel, id);
        if (idx !== -1)
            listModel.remove(idx);
    }
}