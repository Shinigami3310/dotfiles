pragma Singleton
import QtQuick

// Конфиг музыкального плеера: размеры и отступы.
QtObject {
    readonly property int surfaceWidth: 360
    readonly property int surfaceHeight: 100
    readonly property int surfaceMargin: 14

    readonly property int playbackSpacing: 8
    readonly property int marqueeSpacing: 40
    readonly property int trackTextSize: 18
    readonly property int marqueeMinDuration: 3000
    readonly property real marqueeDurationPerPixel: 30

    readonly property int playlistMargin: 14
    readonly property int playlistSpacing: 12
    readonly property int playlistTextSize: 18
}