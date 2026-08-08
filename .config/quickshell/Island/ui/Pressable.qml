import QtQuick
import "../theme"

// Базовый интерактивный элемент: hover/pressed/scale-анимация.
// Заменяет дублирующийся паттерн в IconButton, ToggleSwitch, WorkspaceDot,
// DayCell, NavButton.
Item {
    id: root

    property bool enabled: true
    property real hoverScale: Theme.scaleHover
    property real pressedScale: Theme.scalePressed
    property int acceptedButtons: Qt.LeftButton

    signal clicked

    readonly property bool hovered: hoverHandler.hovered
    property bool pressed: tapHandler.pressed

    scale: pressed ? pressedScale : (hovered ? hoverScale : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutBack
        }
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        enabled: root.enabled
        acceptedButtons: root.acceptedButtons
        onTapped: root.clicked()
    }
}