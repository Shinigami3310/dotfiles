pragma Singleton
import QtQuick

QtObject {
    readonly property int filterDotSize: 10
    readonly property int filterDotBorderWidth: 1

    readonly property int cardRadius: 12
    readonly property int cardRadiusCompact: 8
    readonly property int cardPadding: 12
    readonly property int cardPaddingCompact: 8
    readonly property int cardVPadding: 10
    readonly property int cardBorderWidth: 1
    readonly property int cardBorderWidthCompact: 1

    readonly property int contentSpacing: 8
    readonly property int iconSize: 24
    readonly property int iconSizeCompact: 18
    readonly property int closeButtonSize: 20
    readonly property int closeButtonSizeCompact: 16

    readonly property int actionHPadding: 12
    readonly property int actionHPaddingCompact: 8
    readonly property int actionHeight: 28
    readonly property int actionHeightCompact: 22
    readonly property int actionRadius: 6
    readonly property int actionBorderWidth: 1
}
