pragma Singleton
import QtQuick
import "../shared/theme"

QtObject {
    enum Importance { Low, Normal, Critical }
    enum Origin { Dbus, Api }
    enum CloseReason { Expired, Dismissed }

    readonly property string fontFamily: Theme.font

    readonly property int fontTiny: 10
    readonly property int fontSmall: 11
    readonly property int fontMedium: 12
    readonly property int fontSummary: 13
    readonly property int fontLarge: 15

    readonly property int animDuration: Motion.durationStandard
    readonly property int animEasing: Motion.curveMoveIn

    readonly property string labelNotifications: "Notifications"
    readonly property string labelDnd: "DND"
    readonly property string labelClear: "🗑"
    readonly property string labelClose: "✕"
    readonly property string sourceUnknown: "Source not identified"
}
