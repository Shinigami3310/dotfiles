import Quickshell
import QtQuick

QtObject {
    id: root

    function openMenu() {
        Quickshell.execDetached(["qs", "-c", "PowerMenu"]);
    }
}
