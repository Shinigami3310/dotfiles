import QtQuick
import QtCore as QtSys
import "../config"
import "../ui/toasts"

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
        // Не стартуем, пока нет хранилища и сервиса уведомлений.
        if (!store) {
            console.warn("[NotificationService] start() skipped: store is not ready");
            return;
        }
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
        if (imp === Constants.Importance.Low && !filterLow)
            return false;
        if (imp === Constants.Importance.Normal && !filterNormal)
            return false;
        if (imp === Constants.Importance.Critical && !filterCritical)
            return false;
        if (dndEnabled)
            return imp === Constants.Importance.Critical && Settings.allowCriticalInDnd;
        return true;
    }

    function notify(input) {
        if (!running || !store)
            return null;

        try {
            const request = Object.assign({}, input ?? {}, {
                // Валидация: action должны быть массивом объектов с ключами
                actions: Array.isArray(input?.actions) ? input.actions : []
            });
            if (request.replacesId > 0) {
                request.dbusId = request.replacesId;
                request.id = "dbus-" + request.replacesId;
            }

            const notification = modelFactory.createNotification(request);

            _cancelTimer(notification.id);
            store.add(notification);

            // Внешнее закрытие (приложение вызвало CloseNotification по DBus)
            if (notification.rawNotification) {
                if (typeof notification.rawNotification.closed?.connect === "function") {
                    notification.rawNotification.closed.connect(() => {
                        _cancelTimer(notification.id);
                        store?.removeById(notification.id);
                    });
                }
            }

            if (shouldShowToast(notification)) {
                store.addToast(notification);
                _scheduleRemoval(notification);
            }
            return notification.id;
        } catch (e) {
            console.warn("[NotificationService] notify() failed:", e);
            return null;
        }
    }

    function close(id, reason) {
        reason = reason ?? Constants.CloseReason.Dismissed;
        const notif = store?.findById(id);
        if (notif?.rawNotification) {
            const method = reason === Constants.CloseReason.Expired ? "expire" : "dismiss";
            if (typeof notif.rawNotification[method] === "function")
                notif.rawNotification[method]();
        }
        _cancelTimer(id);
        store?.removeById(id);
    }

    function closeToastOnly(id, reason) {
        reason = reason ?? Constants.CloseReason.Dismissed;
        _cancelTimer(id);
        store?.removeToastById(id);
    }

    function invokeAction(id, actionKey) {
        const notif = store?.findById(id);
        if (notif?.rawNotification) {
            const actions = notif.rawNotification.actions;
            if (actions) {
                for (const act of actions) {
                    if (act.identifier === actionKey) {
                        if (typeof act.invoke === "function") {
                            try {
                                act.invoke();
                            } catch (e) {
                                console.warn("[NotificationService] invokeAction failed:", e);
                            }
                        }
                        break;
                    }
                }
            }
        }
        close(id, Constants.CloseReason.Dismissed);
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
            if (notification.importance === Constants.Importance.Critical)
                return;
            timeoutMs = notification.importance === Constants.Importance.Low ? ToastsConfig.timeoutLowMs : ToastsConfig.timeoutNormalMs;
        }
        const timer = _createTimer();
        timer.interval = timeoutMs;
        timer.repeat = false;
        timer.triggered.connect(() => closeToastOnly(notification.id, Constants.CloseReason.Expired));
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