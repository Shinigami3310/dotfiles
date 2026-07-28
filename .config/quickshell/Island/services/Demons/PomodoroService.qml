pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    property bool active: false
    property bool isWorking: true
    property int currentCycle: 1

    readonly property int workDuration: 25 * 1
    readonly property int shortBreakDuration: 5 * 1

    property int remainingTime: workDuration

    property Timer timer: Timer {
        interval: 1000
        repeat: true
        running: root.active
        onTriggered: {
            if (root.remainingTime > 1) {
                root.remainingTime -= 1;
            } else {
                root.handleTimerComplete();
            }
        }
    }

    function toggle() {
        if (!active) {
            active = true;
            isWorking = true;
            currentCycle = 1;
            remainingTime = workDuration;
            sendCliNotification("Timer start", "Time for work! (Cycle 1)");
        } else {
            resetToInactive();
        }
    }

    function handleTimerComplete() {
        if (isWorking) {
            isWorking = false;
            if (currentCycle === 4) {
                remainingTime = workDuration;
                sendCliNotification("Session done! ☕", "");
                resetToInactive();
            } else {
                remainingTime = shortBreakDuration;
                sendCliNotification("", "Break 5 minutes.");
            }
        } else {
            currentCycle += 1;
            isWorking = true;
            remainingTime = workDuration;
            sendCliNotification("", "Work 25 minutes! (Cycle " + currentCycle + ")");
        }
    }

    function sendCliNotification(title, message) {
        Quickshell.execDetached(["notify-send", "-a", "Pomodoro", title, message]);
    }

    function resetToInactive() {
        active = false;
        isWorking = true;
        currentCycle = 1;
        remainingTime = workDuration;
    }
}
