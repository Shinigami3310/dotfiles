pragma Singleton
import QtQuick

QtObject {
    readonly property int layoutPadding: 52
    readonly property int layoutSpacing: 20
    readonly property int headerSpacing: 16
    readonly property int profileSpacing: 12

    readonly property int frameWidth: 62
    readonly property int frameHeight: 32
    readonly property int frameRadius: 6
    readonly property real borderWidth: 2.5
    readonly property real innerMargin: 3.5
    readonly property int indicatorRadius: 3

    readonly property int terminalWidth: 4
    readonly property int terminalHeight: 12
    readonly property int terminalRadius: 2

    readonly property int textSize: 28
    readonly property int chargeAnimDuration: 2700

    readonly property int profileBtnRadius: 16
    readonly property int profileActiveBorderWidth: 2
}
