import QtQuick
import "../../Singletons"

Item {
    id: root

    property real size: 15
    property int radius: 6
    property url source: ""
    property bool active: false

    signal clicked

    implicitWidth: size
    implicitHeight: size

    readonly property bool hovered: hover.hovered

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: hovered || active ? Theme.hover : "transparent"
        border.width: hovered || active ? 1 : 0
        border.color: active ? Theme.accent : Theme.separator
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
        Behavior on border.width {
            NumberAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    Image {
        anchors.fill: parent
        visible: root.source !== ""
        source: root.source
        asynchronous: true
        cache: true
        smooth: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.size * 2, root.size * 2)
    }

    Text {
        anchors.fill: parent
        visible: root.source === ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: Theme.font
        font.pixelSize: Math.round(root.size)
        font.weight: Font.DemiBold
        color: active ? Theme.accent : Theme.textMuted
        antialiasing: true
        renderType: Text.NativeRendering
    }

    HoverHandler {
        id: hover
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
