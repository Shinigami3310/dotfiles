import QtQuick
import QtQuick.Effects
import "../../../theme"

Item {
    id: root

    // Локальные константы из Config
    readonly property real controlButtonSize: 64
    readonly property real controlImageSize: 28

    property string icon: ""
    property bool active: false
    property bool enableRightClick: false

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: leftTap.pressed || rightTap.pressed

    signal clicked
    signal rightClicked

    implicitWidth: controlButtonSize
    implicitHeight: controlButtonSize

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 12

        border.color: root.active ? ThemeColor.primary : ThemeColor.outline_variant
        border.width: 1

        color: "transparent"

        scale: pressed ? 0.95 : (hovered ? 1.05 : 1.0)

        Behavior on color {
            ColorAnimation {
                duration: Motion.standard
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Motion.standard
                easing.type: Easing.OutBack
            }
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: controlImageSize
            height: controlImageSize
            sourceSize: Qt.size(width * 2, height * 2)
            source: root.icon !== "" ? Qt.resolvedUrl("../../../assets/icons/" + root.icon) : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            visible: false
        }

        MultiEffect {
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: (pressed || root.active || hovered) ? ThemeColor.primary : ThemeColor.on_surface

            Behavior on colorizationColor {
                ColorAnimation {
                    duration: Motion.standard
                }
            }
        }
    }

    // Хэндлер для отслеживания курсора и наведения
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    // Хэндлер клика ЛКМ
    TapHandler {
        id: leftTap
        acceptedButtons: Qt.LeftButton
        onTapped: root.clicked()
    }

    // Хэндлер клика ПКМ (включается только при enableRightClick)
    TapHandler {
        id: rightTap
        enabled: root.enableRightClick
        acceptedButtons: Qt.RightButton
        onTapped: root.rightClicked()
    }
}
