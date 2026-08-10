import QtQuick
import "../../theme"

// Трек слайдера. preventStealing нужен, чтобы drag не перехватывался
// родительским Flickable/ListView — иначе ползунок «дёргается».
Rectangle {
    id: root

    property real value: 0.0
    property bool muted: false
    property real trackHeight: 10
    property real step: 0.02
    readonly property bool pressed: trackMouse.pressed

    signal sliderMoved(real newValue)

    // Внешние размеры задаёт родитель (Slider.qml): width по Layout,
    // здесь только высота и скругление.
    height: trackHeight
    radius: height / 2
    color: ThemeColor.surface_container_high
    border.color: trackMouse.containsMouse ? ThemeColor.primary : ThemeColor.transparent
    border.width: 1
    clip: true

    Behavior on border.color {
        ColorAnimation {
            duration: Motion.fast
        }
    }

    Rectangle {
        id: fillRect
        height: parent.height
        width: parent.width * (root.muted ? 0 : root.value)
        radius: parent.radius
        color: root.muted ? ThemeColor.transparent : ThemeColor.primary

        Behavior on width {
            enabled: !trackMouse.pressed
            NumberAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }
    }

    MouseArea {
        id: trackMouse
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true

        function updatePos(mouseX) {
            const nextValue = Math.max(0.0, Math.min(1.0, mouseX / width));
            root.sliderMoved(nextValue);
        }

        onPressed: mouse => updatePos(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                updatePos(mouse.x);
        }
        onWheel: wheel => {
            const delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
            root.sliderMoved(Math.max(0.0, Math.min(1.0, root.value + delta)));
        }
    }
}
