import QtQuick
import "../shared/theme"

// Базовый интерактивный элемент. Наследуют все кликабельные компоненты,
// чтобы hover/pressed/scale-анимация была единой — иначе каждый компонент
// определяет свою и визуально «разъезжается».
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
