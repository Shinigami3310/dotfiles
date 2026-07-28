import QtQuick
import "../../Singletons"

Item {
    id: root

    property real size: 18
    property int radius: 4
    property url source: ""
    property bool active: false

    signal clicked

    implicitWidth: size
    implicitHeight: size

    readonly property bool hovered: mouseArea.containsMouse

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
        visible: root.source != ""
        source: root.source
        asynchronous: true
        cache: true
        smooth: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.size * 2, root.size * 2)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
