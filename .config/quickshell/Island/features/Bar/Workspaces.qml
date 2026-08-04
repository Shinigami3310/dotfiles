pragma ComponentBehavior: Bound
import QtQuick
import "../../theme"
import "../../services"

Row {
    id: root
    spacing: 12

    WorkspaceService {
        id: handler
    }

    Repeater {
        model: 5
        delegate: WorkspaceDot {
            handler: handler
        }
    }
}
