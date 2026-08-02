import QtQuick
import QtQuick.Effects
import "../../theme"

Item {
    id: root

    property url source: ""
    property bool active: false
    signal clicked

    implicitWidth: Configs.iconSize
    implicitHeight: Configs.iconSize

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

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
        sourceSize: Qt.size(width * 2, height * 2)
    }

    MultiEffect {
        anchors.fill: iconImage
        source: iconImage
        colorization: 1.0
        colorizationColor: (root.active || root.pressed) ? Theme.accent : Theme.text

        Behavior on colorizationColor {
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
