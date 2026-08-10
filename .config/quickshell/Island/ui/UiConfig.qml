pragma Singleton
import QtQuick

// Единый конфиг переиспользуемых UI-примитивов (ui/).
// Размеры и масштабы жестов собраны здесь, чтобы не дублировать их
// в каждой фиче (Bar/Icon, MusicPlayer/IconButton, ControlButton, ProfileButton,
// Slider, ControlSlider, Switch).
QtObject {
    // --- IconButton ---
    readonly property real iconButtonSize: 24
    readonly property real iconButtonRadius: 12
    readonly property real iconButtonIconSize: 24
    readonly property real iconButtonBgSize: 64

    // --- Slider ---
    readonly property real sliderIconBoxSize: 32
    readonly property real sliderIconSize: 24
    readonly property real sliderTrackHeight: 10
    readonly property real sliderTrackDefaultWidth: 200
    readonly property real sliderTextWidth: 32
    readonly property real sliderTextSize: 13
    readonly property real sliderRowHeight: 36
    readonly property real sliderRowTrackHeight: 24
    readonly property real sliderRowRadius: 10
    readonly property real sliderRowIconContainerSize: 36
    readonly property real sliderRowTextWidth: 36
    readonly property real sliderRowTextSize: 11

    // --- ToggleSwitch ---
    readonly property real switchWidth: 44
    readonly property real switchHeight: 24
    readonly property real switchBorderWidth: 1
    readonly property real switchHandleMargin: 3

    // --- OSD panel ---
    readonly property real osdPaddingX: 20
    readonly property real osdPaddingY: 12
    readonly property int osdIdleTimeout: 2500
}