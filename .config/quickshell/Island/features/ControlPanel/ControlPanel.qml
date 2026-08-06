import QtQuick
import QtQuick.Layouts
import "../../theme"
import "./BottomPanel/"
import "./CenterPanel/"
import "./TopPanel/"

Item {
    id: root

    signal surfaceRequested(string newName)

    implicitWidth: ControlPanelConfig.panelWidth + (ControlPanelConfig.panelPadding * 2)
    implicitHeight: mainLayout.implicitHeight + (ControlPanelConfig.panelPadding * 2)

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        width: ControlPanelConfig.panelWidth
        spacing: ControlPanelConfig.rowSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            WifiButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }

            Item {
                Layout.fillWidth: true
            }

            BluetoothButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }

            Item {
                Layout.fillWidth: true
            }

            DndButton {}

            Item {
                Layout.fillWidth: true
            }

            NightModeButton {}
        }

        VolumeSliderRow {
            Layout.fillWidth: true
        }

        BrightnessSliderRow {
            Layout.fillWidth: true
        }

        ResourceRow {
            Layout.fillWidth: true
        }
    }
}
