import QtQuick
import "../surfaces"

// Реестр поверхностей. Каждая запись — Component, создаваемый SurfaceHost
// по имени. Чтобы добавить новую поверхность:
//   1. Создайте surfaces/MySurface.qml на основе SurfaceBase.
//   2. Создайте фичу в features/MyFeature/.
//   3. Добавьте строку: readonly property Component mySurface: MySurface {}
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
