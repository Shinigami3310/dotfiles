import QtQuick
import Quickshell

ShellRoot {
    PowerMenuWindow {
        id: powerMenu

        Component.onCompleted: powerMenu.open()
    }
}
