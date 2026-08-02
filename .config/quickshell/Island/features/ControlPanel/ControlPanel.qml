import QtQuick
import "../../theme"
import "./BottomPanel/"
import "./CenterPanel/"
import "./TopPanel/"

Item {
    id: root

    signal surfaceRequested(string newName)

    implicitWidth: Configs.controlPanelWidth + Configs.controlPanelPadding * 2
    implicitHeight: mainColumn.implicitHeight + Configs.controlPanelPadding * 2

    Column {
        id: mainColumn
        anchors.centerIn: parent
        spacing: 12
        Row {
            spacing: (width - (4 * Configs.controlButtonSize)) / 3
            width: Configs.controlPanelWidth
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
            width: Configs.controlPanelWidth
        }
        BrightnessSliderRow {
            width: Configs.controlPanelWidth
        }
        ResourceRow {
            width: Configs.controlPanelWidth
        }
    }
}
