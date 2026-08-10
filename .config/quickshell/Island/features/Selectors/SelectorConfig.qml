pragma Singleton
import QtQuick

QtObject {
    readonly property real width: 320
    readonly property real maxListHeight: 300
    readonly property real minListHeight: 48
    readonly property real padding: 16
    readonly property real spacing: 16
    readonly property real panelRadius: 16
    readonly property real iconSize: 24
    readonly property real headerSpacing: 12
    readonly property real titleFontSize: 16
    readonly property real iconOpacityDisabled: 0.5

    readonly property real cardSpacing: 6

    readonly property real cardBaseHeight: 48
    readonly property real cardInputHeight: 88
    readonly property real cardRadius: 12
    readonly property real cardBorderWidth: 1
    readonly property real cardContentMargin: 12
    readonly property real cardContentSpacing: 8
    readonly property real cardTextSize: 13
    readonly property int pulseDuration: 600
    readonly property real pulseMinOpacity: 0.4

    readonly property real inputContainerHeight: 28
    readonly property real inputRadius: 6
    readonly property real inputPadding: 8

    readonly property real scaleHover: 1.0
    readonly property real scalePressed: 0.9
}
