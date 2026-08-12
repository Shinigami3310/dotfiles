import QtQuick
import Quickshell
import "../../shared/theme"
import "../../core"
import "."

Item {
    id: root

    signal surfaceRequested(string name)

    // Стартовая «заглушка» при запуске shell. Показываем только время
    // — это привычный и ненавязчивый виджет, не требующий действий.
    readonly property int paddingX: HomeClockConfig.paddingX
    readonly property int paddingY: HomeClockConfig.paddingY

    implicitWidth: timeText.implicitWidth + (paddingX * 2)
    implicitHeight: timeText.implicitHeight + (paddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatTime(clock.date, "hh:mm")
        font {
            family: Theme.font
            pixelSize: HomeClockConfig.textPixelSize
            weight: Font.Normal
        }
        color: ThemeColor.on_surface
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested(SurfaceNames.bar)
    }
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
