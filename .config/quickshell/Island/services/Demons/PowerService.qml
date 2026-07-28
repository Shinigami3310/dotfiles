pragma Singleton

import Quickshell
import QtQuick

QtObject {

    signal closeRequested

    function openMenu() {
        Quickshell.execDetached(["qs", "-c", "PowerMenu"]);
        closeRequested();
    }
}
