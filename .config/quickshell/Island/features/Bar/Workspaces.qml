pragma ComponentBehavior: Bound
import QtQuick
import "../../theme"

Row {
    id: root
    spacing: 12

    Repeater {
        model: 5
        delegate: WorkspaceDot {}
    }
}
