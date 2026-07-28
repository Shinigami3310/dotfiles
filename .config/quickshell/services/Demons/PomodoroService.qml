pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    property bool active: true

    function toggle() {
        active = !active;
    }
}
