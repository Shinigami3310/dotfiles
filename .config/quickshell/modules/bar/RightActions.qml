import QtQuick
import "../../Singletons"

Item {
    id: root

    property int buttonSize: 25
    property int spacing: 8

    signal settingsClicked
    signal batteryClicked
    signal powerClicked

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.spacing

        ActionIcon {
            size: root.buttonSize
            glyph: "⚙"
            onClicked: root.settingsClicked()
        }

        ActionIcon {
            size: root.buttonSize
            glyph: "▣"
            onClicked: root.batteryClicked()
        }

        ActionIcon {
            size: root.buttonSize
            glyph: "⏻"
            onClicked: root.powerClicked()
        }
    }
}
