import Quickshell
import QtQuick

QtObject {
    id: root
    signal closeRequested

    function openMenu() {
        Quickshell.execDetached(["qs", "-c", "PowerMenu"]);
        root.closeRequested();
    }
}
