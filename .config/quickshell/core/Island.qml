import QtQuick
import "../Singletons"

Item {
    id: root
    property int paddingX: 18
    property int paddingY: 10
    property int radius: 24
    property int borderWidth: 0

    property color backgroundColor: Theme.panelBg
    property color borderColor: Theme.panelBorder

    default property alias contentData: content.data

    clip: true

    implicitWidth: content.implicitWidth + paddingX * 2
    implicitHeight: content.implicitHeight + paddingY * 2

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Motion.expand
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.expand
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
        anchors.centerIn: parent
        clip: true

        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
