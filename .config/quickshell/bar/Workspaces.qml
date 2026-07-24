pragma ComponentBehavior: Bound

import QtQuick
import "../Singletons"
import "../services"

Item {
    id: root

    property int firstWorkspaceId: 1
    property int dotCount: 5

    property real dotSize: 10
    property real gap: 12

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
                id: slot
                required property int index

                readonly property int workspaceId: root.firstWorkspaceId + index
                readonly property bool active: handler.isCurrent(workspaceId)
                readonly property bool occupied: handler.isOccupied(workspaceId)
                readonly property bool hovered: area.containsMouse

                width: root.dotSize
                height: root.dotSize
                scale: area.containsMouse ? 1.5 : 1.0
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

                    border.width: !occupied ? 1 : 0
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

                    Behavior on border.width {
                        NumberAnimation {
                            duration: Motion.fast
                            easing.type: Motion.easeStandard
                        }
                    }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent

                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton

                    onClicked: {
                        handler.activateWorkspace(workspaceId);
                    }
                }
                HoverHandler {
                    id: hoverHandler
                }
            }
        }
    }
}
