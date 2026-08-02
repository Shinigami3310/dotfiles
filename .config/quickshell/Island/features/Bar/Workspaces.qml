pragma ComponentBehavior: Bound
import QtQuick
import "../../theme"
import "../../services"

Row {
    id: root
    spacing: Configs.workspaceGap

    WorkspaceService {
        id: handler
    }

    Repeater {
        model: Configs.workspaceCount
        delegate: WorkspaceDot {
            handler: handler
        }
    }
}
