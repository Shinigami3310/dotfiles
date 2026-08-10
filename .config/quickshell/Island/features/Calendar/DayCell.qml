import QtQuick
import "../../shared/theme"
import "../../ui"

// Ячейка дня календаря. disabled для дней вне месяца, чтобы они не
// срабатывали по клику и не «подсвечивались» при наведении — иначе
// пользователь пытается кликнуть по пустой клетке.
Pressable {
    id: root

    property int dayNumber: 0
    property bool inMonth: false
    property bool selected: false
    property bool isToday: false
    property bool isPast: false

    enabled: root.inMonth

    width: CalendarConfig.cellSize
    height: CalendarConfig.cellSize

    opacity: isPast ? CalendarConfig.pastDayOpacity : 1.0

    Rectangle {
        anchors.fill: parent
        radius: CalendarConfig.cellRadius
        color: root.hovered ? ThemeColor.surface_container_high : ThemeColor.transparent

        border {
            width: (root.selected || root.isToday || root.hovered) ? CalendarConfig.cellBorderWidth : 0
            color: (root.selected || root.isToday) ? ThemeColor.primary : ThemeColor.outline_variant
        }

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
    }

    Text {
        anchors.centerIn: parent
        text: root.inMonth ? root.dayNumber.toString() : ""
        font {
            family: Theme.font
            pixelSize: CalendarConfig.cellTextSize
            weight: root.selected ? Font.Bold : Font.Normal
        }
        color: root.selected || root.isToday ? ThemeColor.primary : ThemeColor.on_surface
    }
}