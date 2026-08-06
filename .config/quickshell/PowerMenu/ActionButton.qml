import QtQuick
import QtQuick.Effects
import "./theme"

Item {
    id: root

    property url source: ""
    property string label: ""

    signal activated

    implicitWidth: 112
    implicitHeight: 124

    activeFocusOnTab: true

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed
    readonly property bool isActive: root.activeFocus || root.pressed || root.hovered

    scale: pressed ? Configs.scalePressed : (hovered || root.activeFocus ? Configs.scaleHover : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: body
        anchors.centerIn: parent
        width: 96
        height: 96
        radius: 26
        antialiasing: true

        readonly property color baseColor: root.isActive ? ThemeColor.surface_container_high : ThemeColor.surface_container
        color: Qt.alpha(baseColor, 0.65)

        border.width: root.isActive ? 2 : 1
        border.color: (root.pressed || root.activeFocus) ? ThemeColor.primary : ThemeColor.outline_variant

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 8

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: 32
                implicitHeight: 32

                Image {
                    id: iconImage
                    anchors.fill: parent
                    source: root.source
                    visible: false
                    asynchronous: true
                    cache: true
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(width, height)
                }

                MultiEffect {
                    anchors.fill: iconImage
                    source: iconImage
                    colorization: 1.0
                    colorizationColor: root.isActive ? ThemeColor.primary : ThemeColor.on_surface

                    paddingRect: Qt.rect(0, 0, width, height)
                    autoPaddingEnabled: false

                    Behavior on colorizationColor {
                        ColorAnimation {
                            duration: Motion.fast
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                color: root.isActive ? ThemeColor.primary : ThemeColor.on_surface
                font.pixelSize: 13
                font.weight: Font.Medium
                font.family: "JetBrains Mono"

                Behavior on color {
                    ColorAnimation {
                        duration: Motion.fast
                    }
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.activated();
            event.accepted = true;
        }
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton
        onTapped: root.activated()
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
}
