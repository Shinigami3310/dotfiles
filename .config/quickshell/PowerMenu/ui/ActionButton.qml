import QtQuick
import QtQuick.Effects
import QtQuick.Window
import "../shared/theme"
import "../theme"

Item {
    id: root

    property url source: ""
    property string label: ""

    signal activated

    readonly property bool highlighted: activeFocus

    implicitWidth: Configs.buttonWidth
    implicitHeight: Configs.buttonHeight

    scale: highlighted ? Theme.scaleHover : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Motion.curveScaleHover
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: Configs.buttonBodySize
        height: Configs.buttonBodySize
        radius: Configs.buttonRadius
        antialiasing: true

        color: Qt.alpha(ThemeColor.surface_container, Configs.buttonAlpha)

        border.width: Configs.buttonBorderWidth
        border.color: root.highlighted ? ThemeColor.primary : ThemeColor.outline_variant

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.durationFast
                easing.type: Motion.curveOpacityOut
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: Configs.buttonSpacing

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Configs.buttonIconSize
                height: Configs.buttonIconSize

                Image {
                    id: iconImage
                    anchors.fill: parent
                    source: root.source
                    visible: false
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: Configs.buttonIconSize * Screen.devicePixelRatio
                    sourceSize.height: Configs.buttonIconSize * Screen.devicePixelRatio
                }

                MultiEffect {
                    anchors.fill: parent
                    source: iconImage
                    colorization: 1.0
                    colorizationColor: root.highlighted ? ThemeColor.primary : ThemeColor.on_surface

                    Behavior on colorizationColor {
                        ColorAnimation {
                            duration: Motion.durationFast
                            easing.type: Motion.curveOpacityOut
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                color: root.highlighted ? ThemeColor.primary : ThemeColor.on_surface
                font.pixelSize: Configs.buttonFontSize
                font.weight: Font.Medium
                font.family: Theme.font

                Behavior on color {
                    ColorAnimation {
                        duration: Motion.durationFast
                        easing.type: Motion.curveOpacityOut
                    }
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return) root.activated();
    }
}
