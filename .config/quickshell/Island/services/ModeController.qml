import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../Singletons"

QtObject {
    id: root

    required property var host

    readonly property bool isFullscreen: Hyprland.focusedWorkspace?.hasFullscreen ?? false

    readonly property Timer timer: Timer {
        id: switchTimer
        interval: Motion.fade * 2 + Motion.standard
        repeat: false
        onTriggered: {
            if (root.isFullscreen) {
                host.close();
            } else {
                host.close();
            }
        }
    }

    onIsFullscreenChanged: switchTimer.restart()
}
