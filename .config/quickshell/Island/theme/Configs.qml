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
    readonly property int batteryLayoutPadding: 32
    readonly property int batteryLayoutSpacing: 20
    readonly property int batteryHeaderSpacing: 16
    readonly property int batteryProfileSpacing: 12

    readonly property int batteryFrameRadius: 6
    readonly property real batteryBorderWidth: 2.5
    readonly property real batteryInnerMargin: 3.5
    readonly property int batteryIndicatorRadius: 3

    readonly property int batteryTerminalWidth: 4
    readonly property int batteryTerminalHeight: 12
    readonly property int batteryTerminalRadius: 2

    readonly property int batteryProfileBtnSize: 68
    readonly property int batteryProfileBtnRadius: 16
    readonly property int batteryProfileIconSize: 24

    readonly property int batteryFrameWidth: 62
    readonly property int batteryFrameHeight: 32
    readonly property int batteryTextSize: 28

    readonly property int batteryChargeAnimDuration: 2700

    // --- Calendar ---
    readonly property int calPaddingX: 18
    readonly property int calPaddingY: 16
    readonly property int calGridGap: 4
    readonly property int calCellSize: 30
    readonly property int calHeaderHeight: 28

    readonly property int calTitleSize: 13
    readonly property int calWeekdaySize: 9
    readonly property int calDayTextSize: 12
    readonly property int calNavIconSize: 18

    readonly property int calTransitionDuration: 300

    // --- Bar / Icons ---
    readonly property int iconSize: 22

    // --- Services ---
    readonly property int eyeReminderInterval: 10 * 60 * 1000
    readonly property int pomodoroWorkTime: 25 * 60
    readonly property int pomodoroBreakTime: 5 * 60

    // --- Eye Surface ---
    readonly property int eyeSurfaceDuration: 10
    readonly property int eyePaddingX: 60
    readonly property int eyePaddingY: 12
    readonly property int eyeTextSize: 22

    // --- Bar ---
    readonly property int barPaddingX: 22
    readonly property int barPaddingY: 8
    readonly property int barBlockSpacing: 32

    // --- Bar / Clock ---
    readonly property int barClockPaddingX: 10
    readonly property int barClockPaddingY: 5
    readonly property int barClockSpacing: 2
    readonly property int barClockTimeSize: 18
    readonly property int barClockDateSize: 10

    // --- Bar / RightActions ---
    readonly property int barActionsSpacing: 8

    // --- AppLauncher ---
    readonly property int appListItemMargin: 12
    readonly property int appListItemSpacing: 12
    readonly property int appSearchIconMargin: 16
    readonly property int appSearchSpacing: 12
    readonly property int appLauncherDebounceDelay: 150
    readonly property int appLauncherWidth: 360
    readonly property int appLauncherPadding: 16
    readonly property int appLauncherSpacing: 8

    // --- App Launcher / SearchBar ---
    readonly property int appSearchHeight: 48
    readonly property int appSearchIconSize: 16
    readonly property int appSearchTextSize: 15
    readonly property int appSearchRadius: 8

    // --- App Launcher / AppList ---
    readonly property int appListMaxHeight: 360
    readonly property int appListItemHeight: 44
    readonly property int appListItemRadius: 6
    readonly property int appListIconSize: 24
    readonly property int appListTitleSize: 14

    // --- OSD Panels (Audio / Brightness) ---
    readonly property int osdIdleTimeout: 3000
    readonly property int osdPaddingX: 32
    readonly property int osdPaddingY: 24

    // --- Slider Component ---
    readonly property int sliderTextWidth: 30
    readonly property int sliderTrackWidth: 180
    readonly property int sliderTrackHeight: 10
    readonly property int sliderIconBoxSize: 32
    readonly property int sliderIconSize: 18
    readonly property int sliderTextSize: 14
}
