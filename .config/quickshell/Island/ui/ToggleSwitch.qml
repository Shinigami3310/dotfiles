import QtQuick
import "../theme"

// Переключатель. Наследует Pressable, чтобы hover/pressed/scale-анимация
// была единой с остальными интерактивными элементами.
Pressable {
    id: root

    property bool checked: false
    signal toggled

    implicitWidth: UiConfig.switchWidth
    implicitHeight: UiConfig.switchHeight

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? ThemeColor.primary : ThemeColor.surface_container_high
        border.color: ThemeColor.outline_variant
        border.width: UiConfig.switchBorderWidth

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: handle
            height: bg.height - (UiConfig.switchHandleMargin * 2)
            width: height
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? (bg.width - width - UiConfig.switchHandleMargin) : UiConfig.switchHandleMargin
            color: root.checked ? ThemeColor.on_primary : ThemeColor.on_surface

            Behavior on x {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }
        }
    }

    onClicked: root.toggled()
}