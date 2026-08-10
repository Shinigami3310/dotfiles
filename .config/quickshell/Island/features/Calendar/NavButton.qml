import QtQuick
import "../../shared/theme"
import "../../ui"

// Кнопка навигации по месяцам (‹ ›). Использует увеличенный hoverScale,
// чтобы стрелка «оживала» сильнее маленькой кнопки — иначе клик по ней
// визуально не ощущается.
Pressable {
    id: root

    property alias text: label.text

    hoverScale: CalendarConfig.navBtnHoverScale

    width: CalendarConfig.navBtnSize
    height: CalendarConfig.navBtnSize

    Text {
        id: label
        anchors.centerIn: parent
        font {
            family: Theme.font
            pixelSize: CalendarConfig.navBtnTextSize
            weight: Font.Bold
        }
        color: root.hovered ? ThemeColor.primary : ThemeColor.on_surface

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }
}