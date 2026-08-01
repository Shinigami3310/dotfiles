import QtQuick
import Quickshell.Hyprland
import "../theme"
import "../core"

QtObject {

    required property SurfaceHost host
    readonly property bool isFullscreen: Hyprland.focusedWorkspace?.hasFullscreen ?? false

    readonly property Timer timer: Timer {
        id: switchTimer
        interval: Motion.fade * 2 + Motion.expand
        repeat: false
        onTriggered: host.close()
    }

    onIsFullscreenChanged: switchTimer.restart()
}
