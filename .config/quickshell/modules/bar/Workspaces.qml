pragma ComponentBehavior: Bound

import QtQuick
import "../../Singletons"
import "../../services"

Item {
    id: root

    property int dotCount: 5
    property real dotSize: 12
    property real gap: 8

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    WorkspaceHandler {
        id: handler
    }

    Row {
        id: row
        spacing: root.gap

        Repeater {
            model: root.dotCount

            delegate: Item {
                required property int index

                readonly property int workspaceId: index + 1
                readonly property bool active: handler.isActive(workspaceId)
                readonly property bool occupied: handler.isOccupied(workspaceId)
                readonly property bool hovered: hover.hovered

                width: root.dotSize
                height: root.dotSize
                scale: hovered ? 1.5 : 1.0
                transformOrigin: Item.Center

                Behavior on scale {
                    NumberAnimation {
                        duration: Motion.fast
                        easing.type: Motion.easeStandard
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2

                    color: active ? Theme.accent : occupied ? Theme.text : "transparent"

                    border.width: occupied || active ? 0 : 1
                    border.color: active ? Theme.accent : Theme.separator

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

                HoverHandler {
                    id: hover
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: handler.activateWorkspace(workspaceId)
                }
            }
        }
    }
}
