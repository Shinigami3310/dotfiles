import QtQuick
import Quickshell
import "../../Singletons"

Item {
    id: root

    signal surfaceRequested(string newName)

    implicitWidth: mainColumn.implicitWidth + 32
    implicitHeight: mainColumn.implicitHeight + 32

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Theme.panelBg
        border.color: Theme.panelBorder
        border.width: 1
    }

    Column {
        id: mainColumn

        anchors.centerIn: parent
        spacing: 12

        // Строка 1: Переключатели
        Row {
            spacing: 6.5
            width: 300

            WifiButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }

            BluetoothButton {
                onSurfaceRequested: newName => root.surfaceRequested(newName)
            }

            DndButton {}

            NightModeButton {}
        }

        // Строка 2: Громкость
        VolumeSliderRow {
            width: 300
        }

        // Строка 3: Яркость
        BrightnessSliderRow {
            width: 300
        }

        // Строка 4: Системные ресурсы
        ResourceRow {
            width: 300
        }
    }
}
