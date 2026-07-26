import QtQuick
import "../core"
import "../Singletons"

SurfaceBase {
    id: root

    surfaceName: "clock"
    persistent: false
    wantsKeyboardFocus: false
    canGoBack: false

    property date dateTime: new Date()
    property real paddingX: 30 // play
    property real paddingY: 5 // play
    property int timePixelSize: 18
    implicitWidth: clockText.implicitWidth + paddingX * 2
    implicitHeight: clockText.implicitHeight + paddingY * 2

    Text {
        id: clockText
        anchors.centerIn: parent

        text: Qt.formatDateTime(root.dateTime, "hh:mm")
        font.family: Theme.font // play
        font.pixelSize: root.timePixelSize // play
        font.weight: Font.Medium // play
        color: Theme.text // colors  matugen
        antialiasing: true
    }

    HoverHandler {
        id: hover
        target: root
        onHoveredChanged: {
            if (hovered && root.active)
                root.surfaceRequested("bar", null);
        }
    }
}
