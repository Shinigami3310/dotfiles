pragma Singleton
import QtQuick
import "../shared/theme"

QtObject {
    readonly property string wallpaperDir: SharedPaths.homeDir + "/Pictures/Wallpapers"
    readonly property string setThemeScriptPath: SharedPaths.configDir + "/ThemePicker/scripts/set-theme"

    readonly property real cardHeightRatio: 0.3

    readonly property real cardAspect: 1.6

    readonly property real spacingRatio: 0.8

    readonly property real bevelRatio: 0.7

    readonly property real centerScaleFactor: 1.5

    readonly property color overlayColor: Qt.rgba(0, 0, 0, 0.6)

    readonly property int navRepeatDelay: 80
}
