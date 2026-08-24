pragma Singleton
import QtQuick

QtObject {
    readonly property string appLauncher: "appLauncher"
    readonly property string bar: "bar"
    readonly property string batteryProfile: "batteryProfile"
    readonly property string bluetoothSelector: "bluetoothSelector"
    readonly property string brightnessSlider: "brightnessSlider"
    readonly property string calendar: "calendar"
    readonly property string controlPanel: "controlPanel"
    readonly property string eyeReminder: "eyeReminder"
    readonly property string homeClock: "homeClock"
    readonly property string musicPlayer: "musicPlayer"
    readonly property string strip: "strip"
    readonly property string volumeSlider: "volumeSlider"
    readonly property string wifiSelector: "wifiSelector"

    readonly property list<string> nonFocusSurfaces: [eyeReminder, brightnessSlider, volumeSlider, strip, homeClock]
}
