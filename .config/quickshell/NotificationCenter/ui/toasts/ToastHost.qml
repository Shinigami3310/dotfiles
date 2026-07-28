import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config"

PanelWindow {
    id: root

    property var store
    property var service

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }

    margins {
        top: Settings.cornerMargin
        right: Settings.cornerMargin
    }

    implicitWidth: 360
    implicitHeight: listView.contentHeight
    color: "transparent"

    ListView {
        id: listView
        anchors.fill: parent
        spacing: Settings.toastSpacing
        interactive: false
        model: root.store ? root.store.activeToastsModel : null

        delegate: ToastItem {
            notification: ({
                    id: model.id,
                    source: model.source,
                    summary: model.summary,
                    text: model.text,
                    icon: model.icon,
                    time: model.time,
                    importance: model.importance
                })
            onDismissRequested: if (root.service)
                root.service.closeToastOnly(model.id)
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "x"
                    from: 120
                    to: 0
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        displaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                NumberAnimation {
                    property: "x"
                    to: 120
                    duration: 200
                }
            }
        }
    }
}
