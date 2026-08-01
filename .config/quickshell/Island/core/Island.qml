import QtQuick
import "../theme"

Rectangle {
    id: root

    anchors.top: parent.top
    anchors.topMargin: isFullscreen ? 0 : 8
    anchors.horizontalCenter: parent.horizontalCenter

    color: Theme.panelBg
    radius: 24
    border.width: 2
    border.color: Theme.panelBorder
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
