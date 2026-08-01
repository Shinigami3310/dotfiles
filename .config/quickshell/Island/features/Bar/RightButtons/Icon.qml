import QtQuick
import Qt5Compat.GraphicalEffects
import "../../../theme"

Item {
    id: root

    property real size: 22
    property url source: ""
    property bool active: false
    readonly property bool pressed: mouseArea.pressed

    signal clicked

    implicitWidth: size
    implicitHeight: size

    readonly property bool hovered: mouseArea.containsMouse

    scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Image {
        id: iconImage
        anchors.fill: parent
        source: root.source
        visible: false
        asynchronous: true
        cache: true
        smooth: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(root.size * 2, root.size * 2)
    }

    ColorOverlay {
        anchors.fill: iconImage
        source: iconImage
        color: (root.active || root.pressed) ? Theme.accent : "#FFFFFF"
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
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
