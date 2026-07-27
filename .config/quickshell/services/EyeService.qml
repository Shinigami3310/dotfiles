import QtQuick
import Quickshell

QtObject {
    id: root

    property bool active: false
    property int intervalMs: 10 * 60 * 1000
    property int eyeDurationMs: 10 * 1000

    signal surfaceRequested(string newName, var payload)
    signal stateChanged(bool active)

    property Timer intervalTimer: Timer {
        id: intervalTimer
        interval: root.intervalMs
        repeat: true
        running: root.active

        onTriggered: {
            root.surfaceRequested("eye", {
                durationMs: root.eyeDurationMs
            });
        }
    }

    function toggle() {
        setActive(!active);
    }

    function setActive(value) {
        active = value;
        intervalTimer.running = value;
        stateChanged(value);

        if (value) {
            surfaceRequested("eye", {
                durationMs: eyeDurationMs
            });
        }
    }

    function trigger() {
        if (!active)
            return;
        surfaceRequested("eye", {
            durationMs: eyeDurationMs
        });
    }
}
