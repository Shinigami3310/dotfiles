import QtQuick
import QtQuick.Layouts
import "../../../services/"
import "../../../theme/"
import "../../../ui"
import "../"

Item {
    id: root

    ServiceClient { service: SystemStatsService }

    implicitHeight: ControlPanelConfig.badgeHeight

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ResourceBadge {
            label: "CPU"
            valueText: Math.round(SystemStatsService.cpu * 100) + "%"
            progress: SystemStatsService.cpu
        }

        HSpacer {}

        ResourceBadge {
            label: "RAM"
            valueText: Math.round(SystemStatsService.ram * 100) + "%"
            progress: SystemStatsService.ram
        }

        HSpacer {}

        ResourceBadge {
            label: "GPU"
            valueText: Math.round(SystemStatsService.gpu * 100) + "%"
            progress: SystemStatsService.gpu
        }

        HSpacer {}

        ResourceBadge {
            label: "DISK"
            valueText: Math.round(SystemStatsService.disk * 100) + "%"
            progress: SystemStatsService.disk
        }

        HSpacer {}

        ResourceBadge {
            label: "TEMP"
            valueText: Math.round(SystemStatsService.temp) + "°C"
            progress: SystemStatsService.temp / 100.0
        }
    }
}
