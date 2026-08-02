pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    signal surfaceRequested(string componentName)

    property string device: "intel_backlight"
    property int current: 0
    property int max: 100
    readonly property real level: current / max
    property bool firstRun: true

    property bool _isInternalChange: false

    Component.onCompleted: fetchTimer.restart()

    function setLevel(value) {
        _isInternalChange = true;
        setTimer.targetPercent = Math.round(value * 100);
        setTimer.restart();
        resetInternalFlagTimer.restart();
    }

    property Timer resetInternalFlagTimer: Timer {
        interval: 500
        onTriggered: root._isInternalChange = false
    }

    property Process monitor: Process {
        command: ["udevadm", "monitor", "-s", "backlight"]
        running: true
        stdout: SplitParser {
            onRead: () => fetchTimer.restart()
        }
    }

    property Timer fetchTimer: Timer {
        interval: 50
        onTriggered: fetcher.running ? restart() : (fetcher.running = true)
    }

    property Process fetcher: Process {
        command: ["brightnessctl", "-m", "-d", root.device]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",");
                if (parts.length >= 5 && parts[0] === root.device) {
                    const cur = parseInt(parts[2], 10);
                    const maxRaw = parseInt(parts[4], 10);

                    if (!isNaN(maxRaw) && maxRaw > 0)
                        root.max = maxRaw;

                    if (!isNaN(cur) && cur !== root.current) {
                        root.current = cur;
                        if (!root._isInternalChange && !root.firstRun) {
                            root.surfaceRequested("brightnessSlider");
                        }
                        root.firstRun = false;
                    }
                }
            }
        }
    }

    property Timer setTimer: Timer {
        interval: 20
        property int targetPercent: 50
        onTriggered: {
            if (setter.running) {
                restart();
            } else {
                setter.command = ["brightnessctl", "-d", root.device, "set", `${targetPercent}%`];
                setter.running = true;
            }
        }
    }

    property Process setter: Process {
        running: false
    }
}
