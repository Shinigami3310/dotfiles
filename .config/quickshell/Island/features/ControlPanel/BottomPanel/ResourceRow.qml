import QtQuick
import QtQuick.Layouts
import "../../../services/"
import "../../../theme/"
import "../../../ui"
import "../"

// Ряд метрик ресурсов. Удерживает синглтон SystemStatsService «в awake»:
// пока панель открыта, идёт периодический опрос CPU/RAM/Temp; при выгрузке
// панели (release) опрос останавливается и не тратит ресурсы в простое.
Item {
    id: root

    Component.onCompleted: SystemStatsService.retain()
    Component.onDestruction: SystemStatsService.release()

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
