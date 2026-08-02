pragma Singleton
import QtQuick
import Quickshell
import "../../theme"

QtObject {
    id: root

    property bool active: false
    property bool isWorking: true
    property int currentCycle: 1
    property int remainingTime: Configs.pomodoroWorkTime

    readonly property Timer timer: Timer {
        interval: 1000
        repeat: true
        running: root.active
        onTriggered: {
            if (root.remainingTime > 1) {
                root.remainingTime--;
            } else {
                root.handleTimerComplete();
            }
        }
    }

    function toggle() {
        if (active) {
            resetToInactive();
        } else {
            active = true;
            isWorking = true;
            currentCycle = 1;
            remainingTime = Configs.pomodoroWorkTime;
            sendCliNotification("Timer start", "Time for work! (Cycle 1)");
        }
    }

    function handleTimerComplete() {
        if (isWorking) {
            isWorking = false;
            if (currentCycle >= 4) {
                sendCliNotification("Session done! ☕", "Take a long break.");
                resetToInactive();
            } else {
                remainingTime = Configs.pomodoroBreakTime;
                sendCliNotification("Break Time", "Break for 5 minutes.");
            }
        } else {
            currentCycle++;
            isWorking = true;
            remainingTime = Configs.pomodoroWorkTime;
            sendCliNotification("Work Time", `Work 25 minutes! (Cycle ${currentCycle})`);
        }
    }

    function sendCliNotification(title, message) {
        Quickshell.execDetached(["notify-send", "-a", "Pomodoro", "-i", "/home/Rostislav/.config/quickshell/Island/assets/icons/PomodoroService.png", title, message]);
    }

    function resetToInactive() {
        active = false;
        isWorking = true;
        currentCycle = 1;
        remainingTime = Configs.pomodoroWorkTime;
    }
}
