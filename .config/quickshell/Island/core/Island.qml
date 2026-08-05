import QtQuick
import "../theme"

Rectangle {
    id: root

    default property alias content: contentContainer.children

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
    }

    color: ThemeColor.surface
    border.width: 2
    border.color: ThemeColor.outline_variant

    radius: 24

    implicitWidth: contentContainer.implicitWidth
    implicitHeight: contentContainer.implicitHeight

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

    Item {
        id: contentContainer
        implicitWidth: children[0].implicitWidth
        implicitHeight: children[0].implicitHeight
    }
}
