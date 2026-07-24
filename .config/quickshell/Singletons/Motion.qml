pragma Singleton

import QtQuick

QtObject {
    // Base timing tokens.
    readonly property int fast: 90
    readonly property int standard: 140
    readonly property int morph: 180
    readonly property int panel: 220
    readonly property int expand: 380
    readonly property int settle: 380

    // Micro-interaction tokens.
    readonly property int hover: 120
    readonly property int click: 70
    readonly property int fade: 280
}
