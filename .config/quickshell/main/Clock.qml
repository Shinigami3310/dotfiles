import Quickshell
import QtQuick

Item {
    id: clock

    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    Text {
        id: clockText
        color: "white"
        font.family: "SF Mono"
        font.letterSpacing: -1
        font.pixelSize: 16
        text: Qt.formatDateTime(systemClock.date, "hh:mm")
    }
}
