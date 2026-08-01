pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property int workDuration: 25 * 60
    readonly property int shortBreakDuration: 5 * 60

    property bool isLoaded: serviceInstance !== null
    property var serviceInstance: null

    property bool isWorking: true
    property int currentCycle: 1
    property int remainingTime: workDuration

    property Component serviceLogic: Component {
        Timer {
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                if (root.remainingTime > 1) {
                    root.remainingTime -= 1;
                } else {
                    root.handleTimerComplete();
                }
            }
        }
    }

    function toggle() {
        if (isLoaded) {
            resetToInactive();
        } else {
            isWorking = true;
            currentCycle = 1;
            remainingTime = workDuration;
            serviceInstance = serviceLogic.createObject(root);
            sendCliNotification("Timer start", "Time for work! (Cycle 1)");
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
        if (serviceInstance) {
            serviceInstance.destroy();
            serviceInstance = null;
        }
        isWorking = true;
        currentCycle = 1;
        remainingTime = workDuration;
    }
}
