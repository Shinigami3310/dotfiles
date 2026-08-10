pragma Singleton
import QtQuick

QtObject {
    enum Importance { Low, Normal, Critical }
    enum Origin { Dbus, Api }
    enum CloseReason { Expired, Dismissed }

    // Шрифты
    readonly property int fontTiny: 10
    readonly property int fontSmall: 11
    readonly property int fontMedium: 12
    readonly property int fontSummary: 13
    readonly property int fontLarge: 15

    // Анимации
    readonly property int animDuration: 200
    readonly property int animEasing: Easing.OutCubic

    // Строки
    readonly property string labelNotifications: "Notifications"
    readonly property string labelDnd: "DND"
    readonly property string labelClear: "🗑"
    readonly property string labelClose: "✕"
    readonly property string sourceUnknown: "Source not identified"
}