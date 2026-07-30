import QtQuick
import "../../services/Demons/"

import "../../Singletons"

Item {
    id: root

    implicitWidth: 300
    implicitHeight: 48

    Row {
        anchors.fill: parent
        spacing: 7.5

        ResourceBadge {
            label: "CPU"
            valueText: Math.round(SystemStatsService.cpu * 100) + "%"
            progress: SystemStatsService.cpu
        }

        ResourceBadge {
            label: "RAM"
            valueText: Math.round(SystemStatsService.ram * 100) + "%"
            progress: SystemStatsService.ram
        }

        ResourceBadge {
            label: "GPU"
            valueText: Math.round(SystemStatsService.gpu * 100) + "%"
            progress: SystemStatsService.gpu
        }

        ResourceBadge {
            label: "DISK"
            valueText: Math.round(SystemStatsService.disk * 100) + "%"
            progress: SystemStatsService.disk
        }

        ResourceBadge {
            label: "TEMP"
            valueText: Math.round(SystemStatsService.temp) + "°C"
            progress: SystemStatsService.temp / 100.0
        }
    }
}
