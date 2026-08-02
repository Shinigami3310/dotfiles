import QtQuick
import "../../../services/"
import "../../../theme/"

Item {
    id: root
    SystemStatsService {
        id: systemStatsService
    }
    implicitHeight: Configs.resourceRowHeight

    Row {
        anchors.fill: parent
        spacing: 7.5

        ResourceBadge {
            label: "CPU"
            valueText: Math.round(systemStatsService.cpu * 100) + "%"
            progress: systemStatsService.cpu
        }

        ResourceBadge {
            label: "RAM"
            valueText: Math.round(systemStatsService.ram * 100) + "%"
            progress: systemStatsService.ram
        }

        ResourceBadge {
            label: "GPU"
            valueText: Math.round(systemStatsService.gpu * 100) + "%"
            progress: systemStatsService.gpu
        }

        ResourceBadge {
            label: "DISK"
            valueText: Math.round(systemStatsService.disk * 100) + "%"
            progress: systemStatsService.disk
        }

        ResourceBadge {
            label: "TEMP"
            valueText: Math.round(systemStatsService.temp) + "°C"
            progress: systemStatsService.temp / 100.0
        }
    }
}
