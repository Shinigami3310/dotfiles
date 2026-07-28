import QtQuick

QtObject {
    id: root

    property bool active: false
    property int workMinutes: 25
    property int restMinutes: 5

    signal stateChanged(bool active)
    signal notificationRequested(string kind, var payload)

    function toggle() {
        setActive(!active);
    }

    function setActive(value) {
        active = value;
        stateChanged(value);
    }

    function start() {
        setActive(true);
    }

    function stop() {
        setActive(false);
    }

    function notifyWork() {
        notificationRequested("pomodoro-work", {
            minutes: workMinutes
        });
    }

    function notifyRest() {
        notificationRequested("pomodoro-rest", {
            minutes: restMinutes
        });
    }
}
