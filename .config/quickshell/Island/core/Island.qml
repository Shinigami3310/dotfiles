import QtQuick
import "../theme"

Rectangle {
    id: root
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    color: ThemeColor.surface
    radius: 24
    border.width: 2
    border.color: ThemeColor.outline_variant
    antialiasing: true

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Motion.standard
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.standard
            easing.type: Easing.InOutQuad
        }
    }
}
