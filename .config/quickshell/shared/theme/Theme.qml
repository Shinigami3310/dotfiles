pragma Singleton

import QtQuick

// Глобальные визуальные константы: шрифт и единые масштабы жестов hover/pressed.
QtObject {
    readonly property string font: "JetBrains Mono"

    property real scaleHover: 1.1
    property real scalePressed: 0.9
}