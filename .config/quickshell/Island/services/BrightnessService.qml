pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../core"

QtObject {
    id: root

    signal surfaceRequested(string componentName)

    property int current: 0
    property int max: 100

    readonly property real level: max > 0 ? current / max : 0
    property bool firstRun: true

    property bool _isInternalChange: false

    Component.onCompleted: fetchTimer.restart()

    function setLevel(value: real) {
        _isInternalChange = true;
        setTimer.targetPercent = Math.round(value * 100);
        setTimer.restart();
        resetInternalFlagTimer.restart();
    }

    // udevadm асинхронен: собственное изменение яркости возвращается
    // как событие. Игнорируем его, иначе OSD мигнёт от собственного действия.
    property Timer resetInternalFlagTimer: Timer {
        interval: ServiceConfig.brightnessResetFlagMs
        onTriggered: root._isInternalChange = false
    }

    property Process monitor: Process {
        command: ["udevadm", "monitor", "-s", "backlight"]
        running: true
        stdout: SplitParser {
            onRead: () => fetchTimer.restart()
        }
    }

    // udevadm шлёт пачку событий на одно изменение — группируем их
    // в одно чтение, иначе каждый чих сенсора запускает процесс.
    property Timer fetchTimer: Timer {
        interval: ServiceConfig.brightnessDebounceMs
        onTriggered: fetcher.running ? restart() : (fetcher.running = true)
    }

    property Process fetcher: Process {
        command: ["brightnessctl", "-m"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",");
                if (parts.length >= 5) {
                    const cur = parseInt(parts[2], 10);
                    const maxRaw = parseInt(parts[4], 10);

                    if (!isNaN(maxRaw) && maxRaw > 0)
                        root.max = maxRaw;

                    if (!isNaN(cur) && cur !== root.current) {
                        root.current = cur;
                        if (!root._isInternalChange && !root.firstRun) {
                            root.surfaceRequested(SurfaceNames.brightnessSlider);
                        }
                        root.firstRun = false;
                    }
                }
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0) {
                console.warn(`[BrightnessService] brightnessctl -m завершился с кодом ${exitCode}`);
            }
        }
    }

    property Timer setTimer: Timer {
        interval: ServiceConfig.brightnessSetDebounceMs
        property int targetPercent: 0
        onTriggered: {
            if (setter.running) {
                restart();
            } else {
                setter.command = ["brightnessctl", "set", `${targetPercent}%`];
                setter.running = true;
            }
        }
    }

    property Process setter: Process {
        running: false
    }
}
