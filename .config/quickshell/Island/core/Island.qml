import QtQuick
import "../shared/theme"

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
            duration: Motion.durationSlow
            easing.type: Motion.curveResize
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.durationSlow
            easing.type: Motion.curveResize
        }
    }

    Item {
        id: contentContainer
        implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
        implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
    }
}
