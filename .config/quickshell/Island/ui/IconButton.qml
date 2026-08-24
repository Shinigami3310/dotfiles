import QtQuick
import QtQuick.Effects
import "../shared/theme"
import "../theme"

Pressable {
    id: root

    property string iconName: ""
    property bool active: false
    property bool showBackground: false
    property bool enableRightClick: false
    property real bgRadius: UiConfig.iconButtonRadius
    property color bgColor: ThemeColor.transparent
    property color bgBorderColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.outline_variant
    property real bgBorderWidth: 1

    signal rightClicked

    implicitWidth: showBackground ? UiConfig.iconButtonBgSize : UiConfig.iconButtonSize
    implicitHeight: showBackground ? UiConfig.iconButtonBgSize : UiConfig.iconButtonSize

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.bgRadius
        color: root.bgColor
        visible: root.showBackground
        border.color: root.bgBorderColor
        border.width: root.bgBorderWidth

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.durationSlow
                easing.type: Motion.curveOpacityOut
            }
        }
    }

    Image {
        id: iconImage
        anchors.centerIn: parent
        width: root.showBackground ? UiConfig.iconButtonIconSize : UiConfig.iconButtonSize
        height: root.showBackground ? UiConfig.iconButtonIconSize : UiConfig.iconButtonSize
        source: root.iconName !== "" ? Paths.icon(root.iconName) : ""
        sourceSize: Qt.size(width * 2, height * 2)
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: true
        cache: true
        visible: false
    }

    MultiEffect {
        anchors.fill: iconImage
        source: iconImage
        colorization: 1.0
        colorizationColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.on_surface

        paddingRect: Qt.rect(0, 0, width, height)
        autoPaddingEnabled: false

        Behavior on colorizationColor {
            ColorAnimation {
                duration: Motion.durationFast
            }
        }
    }

    TapHandler {
        id: rightTap
        enabled: root.enableRightClick
        acceptedButtons: Qt.RightButton
        onTapped: root.rightClicked()
    }
}
