import QtQuick
import "../../config"

Pressable {
    id: root

    property bool active: false
    property color dotColor: Colors.borderNormal

    width: 12
    height: 12

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: active ? dotColor : Colors.surfaceContainer
        border.width: 1
        border.color: dotColor
    }
}