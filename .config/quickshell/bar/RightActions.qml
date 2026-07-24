import QtQuick
import "../Singletons"
import "../core"

Item {
    id: root

    property bool eyeActive: false
    property bool pomodoroActive: false
    property bool settingsActive: false
    property bool batteryActive: false
    property bool powerActive: false

    property int buttonSize: 30
    property int spacing: 8

    signal eyeClicked
    signal pomodoroClicked
    signal settingsClicked
    signal batteryClicked
    signal powerClicked

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.spacing

        IslandButton {
            size: root.buttonSize
            glyph: "◉"
            active: root.eyeActive
            onClicked: root.eyeClicked()
        }

        IslandButton {
            size: root.buttonSize
            glyph: "◔"
            active: root.pomodoroActive
            onClicked: root.pomodoroClicked()
        }

        IslandButton {
            size: root.buttonSize
            glyph: "⚙"
            active: root.settingsActive
            onClicked: root.settingsClicked()
        }

        IslandButton {
            size: root.buttonSize
            glyph: "▣"
            active: root.batteryActive
            onClicked: root.batteryClicked()
        }

        IslandButton {
            size: root.buttonSize
            glyph: "⏻"
            active: root.powerActive
            onClicked: root.powerClicked()
        }
    }
}
