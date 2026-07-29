import QtQuick
import QtCore as QtSys
import "../config"

QtObject {
    id: service

    property NotificationStore store
    property bool running: false

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

    readonly property NotificationModel notificationModel: NotificationModel {
        id: modelFactory
    }

    property var _timers: ({})

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
        const imp = notification.importance;
        if (imp === Constants.importance.low && !filterLow)
            return false;
        if (imp === Constants.importance.normal && !filterNormal)
            return false;
        if (imp === Constants.importance.critical && !filterCritical)
            return false;
        if (dndEnabled)
            return imp === Constants.importance.critical && Settings.allowCriticalInDnd;
        return true;
    }

    function notify(input) {
        if (!running || !store)
            return null;

        if (input.replacesId > 0) {
            input.dbusId = input.replacesId;
            input.id = "dbus-" + input.replacesId;
        }

        const notification = modelFactory.createNotification(input);

        _cancelTimer(notification.id);
        store.add(notification);

        if (shouldShowToast(notification)) {
            store.addToast(notification);
            _scheduleRemoval(notification);
        }
        return notification.id;
    }

    function close(id, reason) {
        reason = reason ?? Constants.closeReason.dismissed;
        const notif = store?.findById(id);
        if (notif?.rawNotification) {
            const method = reason === Constants.closeReason.expired ? "expire" : "dismiss";
            if (typeof notif.rawNotification[method] === "function")
                notif.rawNotification[method]();
        }
        _cancelTimer(id);
        store?.removeById(id);
    }

    function closeToastOnly(id, reason) {
        reason = reason ?? Constants.closeReason.dismissed;
        _cancelTimer(id);
        store?.removeToastById(id);
    }

    function invokeAction(id, actionKey) {
        const notif = store?.findById(id);
        if (notif?.rawNotification?.invokeAction)
            notif.rawNotification.invokeAction(actionKey);
        close(id, Constants.closeReason.dismissed);
    }

    function clear() {
        for (const id in _timers)
            _cancelTimer(id);
        _timers = {};
        store?.clear();
    }

    function pauseTimer(id) {
        const t = _timers[id];
        if (t?.timer?.running) {
            t.timer.stop();
            const elapsed = Date.now() - t.startTime;
            t.remainingMs = Math.max(0, t.remainingMs - elapsed);
        }
    }

    function resumeTimer(id) {
        const t = _timers[id];
        if (t?.timer && t.remainingMs > 0) {
            t.startTime = Date.now();
            t.timer.interval = t.remainingMs;
            t.timer.start();
        }
    }

    function _scheduleRemoval(notification) {
        let timeoutMs = -1;
        if (notification.expireTimeout === 0)
            return;
        if (notification.expireTimeout > 0) {
            timeoutMs = notification.expireTimeout;
        } else {
            if (notification.importance === Constants.importance.critical)
                return;
            timeoutMs = notification.importance === Constants.importance.low ? Settings.toastTimeoutLowMs : Settings.toastTimeoutNormalMs;
        }
        const timer = _createTimer();
        timer.interval = timeoutMs;
        timer.repeat = false;
        timer.triggered.connect(() => closeToastOnly(notification.id, Constants.closeReason.expired));
        _timers[notification.id] = {
            timer,
            startTime: Date.now(),
            remainingMs: timeoutMs
        };
        timer.start();
    }

    function _cancelTimer(id) {
        const t = _timers[id];
        if (t) {
            if (t.timer) {
                t.timer.stop();
                t.timer.destroy();
            }
            delete _timers[id];
        }
    }

    property Component _timerComponent: Component {
        Timer {}
    }
    function _createTimer() {
        return _timerComponent.createObject(service);
    }
}
