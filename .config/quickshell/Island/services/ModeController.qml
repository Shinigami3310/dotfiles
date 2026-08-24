import QtQuick
import Quickshell.Hyprland
import "../shared/theme"
import "../core"

QtObject {

    required property SurfaceHost host
    readonly property bool isFullscreen: Hyprland.focusedWorkspace?.hasFullscreen ?? false

    readonly property Timer timer: Timer {
        id: switchTimer
        interval: Motion.durationSlow * 2 + Motion.durationSlow // wait until switch animation finishes
        repeat: false
        onTriggered: host.close()
    }

    onIsFullscreenChanged: switchTimer.restart()
}
