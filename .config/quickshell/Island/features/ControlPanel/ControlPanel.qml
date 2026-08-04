import QtQuick
import "../../theme"
import "./BottomPanel/"
import "./CenterPanel/"
import "./TopPanel/"

Item {
    id: root

    // Локальные константы из Config
    readonly property real controlPanelWidth: 300
    readonly property real controlPanelPadding: 16
    readonly property real controlButtonSize: 64

    signal surfaceRequested(string newName)

    implicitWidth: controlPanelWidth + controlPanelPadding * 2
    implicitHeight: mainColumn.implicitHeight + controlPanelPadding * 2

    Column {
        id: mainColumn
        anchors.centerIn: parent
        spacing: 12
        Row {
            spacing: (width - (4 * controlButtonSize)) / 3
            width: controlPanelWidth
            WifiButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }
            BluetoothButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }
            DndButton {}
            NightModeButton {}
        }
        VolumeSliderRow {
            width: controlPanelWidth
        }
        BrightnessSliderRow {
            width: controlPanelWidth
        }
        ResourceRow {
            width: controlPanelWidth
        }
    }
}
