import QtQuick
import Quickshell
import Quickshell.Wayland
import "./ui"
import "./shared/theme"

PanelWindow {
  focusable: true
  color: "transparent"

    anchors { left: true; right: true; top: true; bottom: true }
    WlrLayershell.layer: WlrLayer.Overlay

    PowerMenuWindow {
        id: contentRoot
        anchors.fill: parent
        opacity: 0

        onCloseRequested: fadeAnim.start()
        onActionRequested: (command) => {
            Quickshell.execDetached(command)
            fadeAnim.start()
        }
    }

    PropertyAnimation {
        id: enterAnim
        target: contentRoot
        property: "opacity"
        to: 1
        duration: Motion.durationSlow
        easing.type: Motion.curveOpacityIn
    }

    PropertyAnimation {
        id: fadeAnim
        target: contentRoot
        property: "opacity"
        to: 0
        duration: Motion.durationSlow
        easing.type: Motion.curveOpacityOut
        onFinished: Qt.quit()
    }

    Component.onCompleted: enterAnim.start()
}
