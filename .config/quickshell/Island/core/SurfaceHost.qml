import QtQuick
import "../theme"

Item {
    id: root

    property var surfaces: ({})
    property string initialSurfaceName: ""

    property string currentName: ""
    property Item currentItem: null
    property var history: []
    property bool busy: false

    property Item outgoingItem: null
    property string pendingName: ""
    property Item pendingItem: null

    signal surfaceChanged(string name)

    implicitWidth: currentItem?.implicitWidth ?? 0
    implicitHeight: currentItem?.implicitHeight ?? 0

    Connections {
        target: root.currentItem
        ignoreUnknownSignals: true
        function onSurfaceRequested(newName) {
            root.open(newName);
        }
        function onBackRequested() {
            root.back();
        }
        function onCloseRequested() {
            root.close();
        }
    }

    Timer {
        id: resizeTimer
        interval: Motion.standard
        onTriggered: {
            if (root.currentItem)
                fadeIn.restart();
            else
                root.busy = false;
        }
    }

    PropertyAnimation {
        id: fadeOut
        target: root.outgoingItem
        property: "opacity"
        to: 0
        duration: Motion.fade
        easing.type: Easing.InOutQuad

        onStopped: {
            if (!root.busy || !root.outgoingItem || !root.pendingItem)
                return;

            root.outgoingItem.exit(root.pendingName);
            root.outgoingItem.destroy();
            root.outgoingItem = null;

            root.currentItem = root.pendingItem;
            root.currentName = root.pendingName;
            root.pendingItem = null;

            root.currentItem.visible = true;
            root.currentItem.opacity = 0;
            root.currentItem.enter();

            resizeTimer.restart();
        }
    }

    PropertyAnimation {
        id: fadeIn
        target: root.currentItem
        property: "opacity"
        to: 1
        duration: Motion.fade
        easing.type: Easing.InOutQuad

        onStopped: {
            root.busy = false;
            root.surfaceChanged(root.currentName);
        }
    }

    function open(name, pushHistory = true) {
        if (!name || busy)
            return;

        if (currentItem && currentName === name) {
            currentItem.enter();
            return;
        }

        const spec = root.surfaces?.[name];
        if (!spec)
            return;

        if (pushHistory && currentName && history[history.length - 1] !== currentName) {
            history.push(currentName);
        }

        pendingName = name;
        const component = spec.component ?? spec;

        pendingItem = component.createObject(root, {
            surfaceName: name,
            active: false,
            visible: false,
            opacity: 0
        });

        if (!pendingItem)
            return;

        if (!currentItem) {
            currentItem = pendingItem;
            currentName = name;
            pendingItem = null;

            currentItem.visible = true;
            currentItem.opacity = 1;
            currentItem.enter();
            surfaceChanged(currentName);
            return;
        }

        busy = true;
        outgoingItem = currentItem;
        outgoingItem.exit(name);
        fadeOut.restart();
    }

    function back() {
        if (busy)
            return;
        if (history.length > 0)
            open(history.pop(), false);
        else if (currentName !== initialSurfaceName)
            open(initialSurfaceName, false);
    }

    function close() {
        if (busy)
            return;
        if (currentName !== initialSurfaceName) {
            history = [];
            open(initialSurfaceName, false);
        }
    }

    Component.onCompleted: open(initialSurfaceName)
}
