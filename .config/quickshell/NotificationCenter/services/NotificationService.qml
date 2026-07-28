import QtQuick
import QtCore as QtSys
import "../config"

QtObject {
    id: service

    property QtSys.Settings _persistentSettings: QtSys.Settings {
        id: persistentSettings
        location: Qt.resolvedUrl("../config/state.ini")

        property bool dndEnabled: false
        property bool filterLow: true
        property bool filterNormal: true
        property bool filterCritical: true
    }

    property alias dndEnabled: persistentSettings.dndEnabled
    property alias filterLow: persistentSettings.filterLow
    property alias filterNormal: persistentSettings.filterNormal
    property alias filterCritical: persistentSettings.filterCritical

    property var store
    property bool running: false

    property var timerData: ({})

    readonly property NotificationModel notificationModel: NotificationModel {
        id: modelFactory
    }

    function start() {
        running = true;
    }

    function stop() {
        running = false;
        clear();
    }

    function toggleDnd() {
        dndEnabled = !dndEnabled;
    }

    function shouldShowToast(notification) {
        var imp = notification.importance;

        if (imp === Constants.importance.low && !filterLow)
            return false;
        if (imp === Constants.importance.normal && !filterNormal)
            return false;
        if (imp === Constants.importance.critical && !filterCritical)
            return false;

        if (dndEnabled) {
            return (imp === Constants.importance.critical && Settings.allowCriticalInDnd);
        }

        return true;
    }

    function notify(input) {
        if (!running || !store)
            return null;

        var notification = modelFactory.createNotification(input);

        store.add(notification);

        if (shouldShowToast(notification)) {
            store.addToast(notification);
            _scheduleRemoval(notification);
        }

        return notification.id;
    }

    function close(id) {
        _cancelTimer(id);
        if (store)
            store.removeById(id);
    }

    function closeToastOnly(id) {
        _cancelTimer(id);
        if (store)
            store.removeToastById(id);
    }

    function clear() {
        for (var id in timerData) {
            _cancelTimer(id);
        }
        timerData = {};
        if (store)
            store.clear();
    }

    function pauseTimer(id) {
        var t = timerData[id];
        if (t && t.timer && t.timer.running) {
            t.timer.stop();
            var elapsed = Date.now() - t.startTime;
            t.remainingMs = Math.max(0, t.remainingMs - elapsed);
        }
    }

    function resumeTimer(id) {
        var t = timerData[id];
        if (t && t.timer && t.remainingMs > 0) {
            t.startTime = Date.now();
            t.timer.interval = t.remainingMs;
            t.timer.start();
        }
    }

    function _scheduleRemoval(notification) {
        if (notification.importance === Constants.importance.critical)
            return;

        var timeoutMs = (notification.importance === Constants.importance.low) ? Settings.toastTimeoutLowMs : Settings.toastTimeoutNormalMs;

        var timer = Qt.createQmlObject("import QtQuick; Timer {}", service);
        timer.interval = timeoutMs;
        timer.repeat = false;

        timerData[notification.id] = {
            timer: timer,
            startTime: Date.now(),
            remainingMs: timeoutMs
        };

        timer.triggered.connect(function () {
            closeToastOnly(notification.id);
        });

        timer.start();
    }

    function _cancelTimer(id) {
        var t = timerData[id];
        if (t) {
            if (t.timer) {
                t.timer.stop();
                t.timer.destroy();
            }
            delete timerData[id];
        }
    }
}
