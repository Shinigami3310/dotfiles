import QtQuick
import "../surfaces"

QtObject {
    readonly property Component appLauncher: AppLauncherSurface {}
    readonly property Component bar: BarSurface {}
    readonly property Component batteryProfile: BatteryProfileSurface {}
    readonly property Component bluetoothSelector: BluetoothSelectorSurface {}
    readonly property Component brightnessSlider: BrightnessSliderSurface {}
    readonly property Component calendar: CalendarSurface {}
    readonly property Component controlPanel: ControlPanelSurface {}
    readonly property Component eyeReminder: EyeReminderSurface {}
    readonly property Component homeClock: HomeClockSurface {}
    readonly property Component musicPlayer: MusicPlayerSurface {}
    readonly property Component strip: StripSurface {}
    readonly property Component volumeSlider: VolumeSliderSurface {}
    readonly property Component wifiSelector: WifiSelectorSurface {}
}
