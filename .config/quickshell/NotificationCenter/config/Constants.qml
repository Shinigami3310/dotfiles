pragma Singleton
import QtQuick
import "../shared/theme"

QtObject {
    enum Importance { Low, Normal, Critical }
    enum Origin { Dbus, Api }
    enum CloseReason { Expired, Dismissed }

    // Единая гарнитура всей экосистемы (один источник — shared/theme).
    readonly property string fontFamily: Theme.font

    // Размеры шрифтов (адаптированы под NC).
    readonly property int fontTiny: 10
    readonly property int fontSmall: 11
    readonly property int fontMedium: 12
    readonly property int fontSummary: 13
    readonly property int fontLarge: 15

    // Анимации — единые токены из shared/theme/Motion (консистентно с Island).
    readonly property int animDuration: Motion.standard
    readonly property int animEasing: Motion.easeOutCubic

    // Строки
    readonly property string labelNotifications: "Notifications"
    readonly property string labelDnd: "DND"
    readonly property string labelClear: "🗑"
    readonly property string labelClose: "✕"
    readonly property string sourceUnknown: "Source not identified"
}
