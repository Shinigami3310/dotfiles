import QtQuick
import "../Singletons"

Item {
    id: root

    property int radius: Math.min(height / 2, 50)
    implicitWidth: content.width
    implicitHeight: content.height

    width: implicitWidth
    height: implicitHeight

    property color backgroundColor: Theme.panelBg

    clip: true

    Behavior on width {
        NumberAnimation {
            duration: Motion.expand
            easing.type: Easing.OutQuad
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Motion.expand
            easing.type: Easing.OutQuad
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.backgroundColor
    }

    Item {
        id: content
        anchors.fill: parent
        clip: true
    }
}
