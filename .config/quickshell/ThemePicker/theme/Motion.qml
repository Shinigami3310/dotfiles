pragma Singleton

import QtQuick

// Длительности и easing-типы анимаций (паттерн из PowerMenu/Island).
QtObject {
    readonly property real mult: 1.0

    readonly property int fast: Math.round(90 * mult)
    readonly property int standard: Math.round(240 * mult)
    readonly property int morph: Math.round(180 * mult)
    readonly property int expand: Math.round(380 * mult)
    readonly property int fade: Math.round(280 * mult)
    readonly property int hover: Math.round(120 * mult)
    readonly property int click: Math.round(70 * mult)

    readonly property int easeStandard: Easing.InOutQuad
    readonly property int easeOut: Easing.OutQuad
    readonly property int easeIn: Easing.InQuad
}