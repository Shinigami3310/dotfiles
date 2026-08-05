pragma Singleton
import QtQuick

QtObject {
    readonly property int baseWidth: 360
    readonly property int windowPadding: 16
    readonly property int windowRadius: 12
    readonly property int windowBorderWidth: 1
    readonly property int layoutSpacing: 8
    readonly property int resizeDebounceInterval: 150

    readonly property int searchBarHeight: 48
    readonly property int searchBarRadius: 8
    readonly property int searchBarBorderWidth: 2
    readonly property int searchBarHorizontalPadding: 16
    readonly property int searchBarSpacing: 12
    readonly property int searchIconSize: 16
    readonly property int searchInputSize: 15

    readonly property int listMaxHeight: 360
    readonly property int listSpacing: 2
    readonly property int listAnimOffsetY: -10

    readonly property int itemHeight: 44
    readonly property int itemRadius: 6
    readonly property int itemActiveBorderWidth: 1
    readonly property int itemHorizontalPadding: 12
    readonly property int itemSpacing: 12
    readonly property int itemIconSize: 24
    readonly property int itemIconRadius: 4
    readonly property int itemTextSize: 14
}
