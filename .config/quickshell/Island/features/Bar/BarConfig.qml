pragma Singleton
import QtQuick

QtObject {
    readonly property int spacing: 32
    readonly property int paddingX: 24
    readonly property int paddingY: 8

    // Clock
    readonly property int clockPaddingX: 12
    readonly property int clockPaddingY: 8
    readonly property int clockSpacing: 8
    readonly property int clockDateSize: 10
    readonly property int clockTimeSize: 18

    // RightActions
    readonly property int rightActionsSpacing: 8

    // Workspaces
    readonly property int workspacesSpacing: 12

    // WorkspaceDot
    readonly property int dotSize: 16
    readonly property int dotBorderWidth: 2
}
