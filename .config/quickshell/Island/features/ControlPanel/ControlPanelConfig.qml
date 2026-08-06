pragma Singleton
import QtQuick

QtObject {
    readonly property real panelWidth: 300
    readonly property real panelPadding: 16
    readonly property real rowSpacing: 16

    readonly property real buttonSize: 64
    readonly property real buttonIconSize: 28
    readonly property real buttonRadius: 12
    readonly property real buttonHoverScale: 1.05
    readonly property real buttonPressedScale: 0.95

    readonly property real sliderHeight: 36
    readonly property real sliderTrackHeight: 24
    readonly property real sliderRadius: 10
    readonly property real sliderIconSize: 24
    readonly property real sliderIconContainerSize: 36
    readonly property real sliderTextWidth: 36
    readonly property real sliderTextSize: 11

    readonly property real badgeWidth: 54
    readonly property real badgeHeight: 48
    readonly property real badgeRadius: 10
    readonly property real badgeLabelSize: 10
    readonly property real badgeValueSize: 11
}
