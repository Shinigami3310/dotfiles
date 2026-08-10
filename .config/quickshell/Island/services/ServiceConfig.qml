pragma Singleton
import QtQuick

// Тайминги и константы сервисов. Централизованы, чтобы не хардкодить
// магические числа в каждом сервисе.
QtObject {
    // AudioService
    readonly property int audioResetFlagMs: 500
    readonly property int audioDebounceMs: 30

    // BrightnessService
    readonly property int brightnessResetFlagMs: 600
    readonly property int brightnessDebounceMs: 50
    readonly property int brightnessSetDebounceMs: 20

    // BatteryService
    readonly property int batteryPollMs: 5000

    // BluetoothService
    readonly property int bluetoothSleepMs: 1000
    readonly property int bluetoothThrottleMs: 500
    readonly property int bluetoothStateCheckMs: 5000
    readonly property int bluetoothRetryMs: 1000

    // WifiService
    readonly property int wifiSleepMs: 1000
    readonly property int wifiSyncMs: 5000

    // SystemStatsService
    readonly property int statsPollMs: 2000

    // DndService
    readonly property int dndSleepMs: 1000

    // EyeReminderService
    readonly property int eyeReminderIntervalMs: 10 * 60 * 1000

    // PomodoroService
    readonly property int pomodoroWorkSec: 25 * 60
    readonly property int pomodoroBreakSec: 5 * 60
    readonly property int pomodoroLongBreakAfterCycles: 4

    // MusicPlayerService
    readonly property string mpvSocketPath: "/tmp/qsh-mpv.sock"
}