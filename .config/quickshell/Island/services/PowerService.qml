pragma Singleton
import Quickshell
import QtQuick
import "../shared/theme"
import "../theme"

QtObject {
    id: root

    function openMenu() {
        Quickshell.execDetached(["qs", "-c", Paths.powerMenuConfig]);
    }
}
