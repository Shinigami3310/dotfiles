import QtQuick
import "../config"

QtObject {
    id: store

    readonly property ListModel historyModel: ListModel {}
    readonly property ListModel activeToastsModel: ListModel {}

    function add(notification) {
        historyModel.insert(0, notification);
        if (historyModel.count > Settings.maxHistoryItems) {
            historyModel.remove(historyModel.count - 1);
        }
    }

    function addToast(notification) {
        activeToastsModel.insert(0, notification);
        if (activeToastsModel.count > Settings.toastMaxVisible) {
            activeToastsModel.remove(activeToastsModel.count - 1);
        }
    }

    function removeById(id) {
        _removeFromModel(historyModel, id);
        _removeFromModel(activeToastsModel, id);
    }

    function removeToastById(id) {
        _removeFromModel(activeToastsModel, id);
    }

    function clear() {
        historyModel.clear();
        activeToastsModel.clear();
    }

    function _removeFromModel(listModel, id) {
        for (var i = 0; i < listModel.count; i++) {
            if (listModel.get(i).id === id) {
                listModel.remove(i);
                break;
            }
        }
    }
}
