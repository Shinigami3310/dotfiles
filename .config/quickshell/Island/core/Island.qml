import QtQuick
import "../theme"

Item {
    id: root
    property int radius: 24
    property int borderWidth: 2

    property color backgroundColor: Theme.panelBg
    property color borderColor: Theme.panelBorder

    default property alias contentData: content.data

    clip: true

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

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

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.backgroundColor
        border.width: root.borderWidth
        border.color: root.borderColor
        antialiasing: true
    }

    Item {
        id: content
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
