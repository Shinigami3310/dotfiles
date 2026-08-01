pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root
    property int intervalMs: 10 * 60 * 1000
    property bool isLoaded: serviceInstance !== null
    property var serviceInstance: null

    signal surfaceRequested(string newName)

    property Component serviceLogic: Component {
        Timer {
            interval: root.intervalMs
            repeat: true
            running: true
            onTriggered: root.surfaceRequested("eyeReminder")
        }
    }

    function toggle() {
        if (serviceInstance) {
            serviceInstance.destroy();
            serviceInstance = null;
        } else {
            serviceInstance = serviceLogic.createObject(root);
        }
    }

    Component.onCompleted: {
        if (!serviceInstance) {
            serviceInstance = serviceLogic.createObject(root);
        }
    }
}
