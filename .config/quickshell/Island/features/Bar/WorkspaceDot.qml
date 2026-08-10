import QtQuick
import "../../theme"
import "../../services/"
import "../../ui"

// Точка рабочего стола. Цвет кодирует состояние (активна/занята/пуста),
// чтобы пользователь видел статус без чтения текста — это быстрее сканируется.
Pressable {
    id: root

    required property int index

    readonly property int workspaceId: index + 1

    readonly property bool isActive: WorkspaceService.isActive(workspaceId)
    readonly property bool isOccupied: WorkspaceService.isOccupied(workspaceId)

    hoverScale: 1.2

    width: BarConfig.dotSize
    height: BarConfig.dotSize

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.isActive ? ThemeColor.primary : (root.isOccupied ? ThemeColor.on_surface : ThemeColor.transparent)

        border {
            width: BarConfig.dotBorderWidth
            color: root.isActive ? ThemeColor.primary : ThemeColor.on_surface
        }

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    onClicked: WorkspaceService.activateWorkspace(workspaceId)
}