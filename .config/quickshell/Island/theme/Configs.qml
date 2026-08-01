pragma Singleton

import QtQuick

QtObject {
    // --- HomeClock ---
    readonly property int clockPaddingX: 40
    readonly property int clockPaddingY: 8
    readonly property int clockPixelSize: 18

    // --- Strip ---
    readonly property int stripWidth: 60
    readonly property int stripHeight: 12

    // --- Workspaces ---
    readonly property int workspaceCount: 5
    readonly property int workspaceDotSize: 12
    readonly property int workspaceGap: 8

    // --- Battery ---
    readonly property int batteryProfileBtnSize: 68
    readonly property int batteryProfileBtnRadius: 16
    readonly property int batteryProfileIconSize: 24

    readonly property int batteryFrameWidth: 62
    readonly property int batteryFrameHeight: 32
    readonly property int batteryTextSize: 28

    readonly property int batteryChargeAnimDuration: 2700
}
