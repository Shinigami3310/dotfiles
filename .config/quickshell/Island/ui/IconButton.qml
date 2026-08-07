import QtQuick
import QtQuick.Effects
import "../theme"

// Единая иконка-кнопка. Заменяет дубликаты: features/Bar/Icon,
// features/MusicPlayer/IconButton, features/ControlPanel/TopPanel/ControlButton,
// features/Battery/ProfileButton.
// - showBackground: рисует скруглённый фон-подложку (для ControlButton/ProfileButton).
// - enableRightClick: включает правый клик (для ControlButton).
// - iconName: имя файла в assets/icons/ — резолвится через Paths.icon(),
//   поэтому не зависит от относительного пути вызывающего файла.
Item {
    id: root

    property string iconName: ""
    property string source: ""
    property bool active: false
    property bool showBackground: false
    property bool enableRightClick: false
    property real bgRadius: UiConfig.iconButtonRadius
    property color bgColor: "transparent"
    property color bgBorderColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.outline_variant
    property real bgBorderWidth: 1

    signal clicked
    signal rightClicked

    implicitWidth: showBackground ? UiConfig.iconButtonBgSize : UiConfig.iconButtonSize
    implicitHeight: showBackground ? UiConfig.iconButtonBgSize : UiConfig.iconButtonSize

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: leftTap.pressed || rightTap.pressed

    scale: pressed ? Configs.scalePressed : (hovered ? Configs.scaleHover : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutBack
        }
    }

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
                duration: Motion.standard
                easing.type: Easing.OutCubic
            }
        }
    }

    Image {
        id: iconImage
        anchors.centerIn: parent
        width: root.showBackground ? UiConfig.iconButtonIconSize : UiConfig.iconButtonSize
        height: root.showBackground ? UiConfig.iconButtonIconSize : UiConfig.iconButtonSize
        source: root.source !== "" ? root.source : (root.iconName !== "" ? Paths.icon(root.iconName) : "")
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
                duration: Motion.fast
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: leftTap
        acceptedButtons: Qt.LeftButton
        onTapped: root.clicked()
    }

    TapHandler {
        id: rightTap
        enabled: root.enableRightClick
        acceptedButtons: Qt.RightButton
        onTapped: root.rightClicked()
    }
}
