import QtQuick
import "../../Singletons"

Item {
    id: root

    property real size: 22
    property int radius: 6
    property string glyph: ""
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

    Text {
        anchors.centerIn: parent
        text: root.glyph
        font.family: Theme.font
        font.pixelSize: 20
        font.weight: Font.DemiBold
        color: active ? Theme.accent : Theme.textMuted
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
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
