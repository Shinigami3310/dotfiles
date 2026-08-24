import QtQuick
import "../common"
import "../../config"

Pressable {
    property bool active: false
    property color dotColor: Colors.borderNormal

    width: CommonConfig.filterDotSize
    height: CommonConfig.filterDotSize

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: active ? dotColor : Colors.surfaceContainer
        border.width: CommonConfig.filterDotBorderWidth
        border.color: dotColor
    }
}
