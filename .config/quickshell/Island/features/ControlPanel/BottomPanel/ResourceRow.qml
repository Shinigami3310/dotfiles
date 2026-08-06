import QtQuick
import QtQuick.Layouts
import "../../../services/"
import "../../../theme/"
import "../"

Item {
    id: root

    SystemStatsService {
        id: systemStatsService
    }

    implicitHeight: ControlPanelConfig.badgeHeight

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ResourceBadge {
            label: "CPU"
            valueText: Math.round(systemStatsService.cpu * 100) + "%"
            progress: systemStatsService.cpu
        }

        Item {
            Layout.fillWidth: true
        }

        ResourceBadge {
            label: "RAM"
            valueText: Math.round(systemStatsService.ram * 100) + "%"
            progress: systemStatsService.ram
        }

        Item {
            Layout.fillWidth: true
        }
        ResourceBadge {
            label: "GPU"
            valueText: Math.round(systemStatsService.gpu * 100) + "%"
            progress: systemStatsService.gpu
        }

        Item {
            Layout.fillWidth: true
        }

        ResourceBadge {
            label: "DISK"
            valueText: Math.round(systemStatsService.disk * 100) + "%"
            progress: systemStatsService.disk
        }

        Item {
            Layout.fillWidth: true
        }

        ResourceBadge {
            label: "TEMP"
            valueText: Math.round(systemStatsService.temp) + "°C"
            progress: systemStatsService.temp / 100.0
        }
    }
}
