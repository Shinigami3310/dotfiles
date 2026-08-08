pragma ComponentBehavior: Bound
import QtQuick
import "../../theme"

Row {
    id: root
    spacing: BarConfig.workspacesSpacing

    Repeater {
        model: 5
        delegate: WorkspaceDot {}
    }
}
