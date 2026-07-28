import QtQuick
import "../Singletons"

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

    Item {
        id: stage
        anchors.fill: parent
    }

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
        interval: Motion.expand
        repeat: false
        onTriggered: root._startFadeIn()
    }

    PropertyAnimation {
        id: fadeOut
        target: null
        property: "opacity"
        to: 0
        duration: Motion.fade
        easing.type: Easing.InOutQuad

        onStopped: {
            if (!root.busy || !root.outgoingItem || !root.pendingItem)
                return;
            root._releaseOutgoing();

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
        target: null
        property: "opacity"
        to: 1
        duration: Motion.fade
        easing.type: Easing.InOutQuad

        onStopped: {
            root.busy = false;
            root.surfaceChanged(root.currentName);
        }
    }

    function _spec(name) {
        return (surfaces && surfaces[name]) ? surfaces[name] : null;
    }

    function _createSurface(name) {
        const spec = _spec(name);
        if (!spec)
            return null;

        const component = spec.component !== undefined ? spec.component : spec;
        return component.createObject(root, {
            surfaceName: name,
            active: false,
            visible: false,
            opacity: 0
        });
    }

    function _releaseOutgoing() {
        if (!outgoingItem)
            return;
        const item = outgoingItem;
        item.exit(pendingName);
        item.destroy();
        outgoingItem = null;
    }

    function _startFadeIn() {
        if (!currentItem) {
            busy = false;
            return;
        }
        fadeIn.target = currentItem;
        fadeIn.restart();
    }

    function open(name, pushHistory) {
        if (!name || busy)
            return;

        if (currentItem && currentName === name) {
            currentItem.enter();
            return;
        }

        const spec = _spec(name);
        if (!spec)
            return;

        if (pushHistory !== false && currentName !== "" && (history.length === 0 || history[history.length - 1] !== currentName)) {
            history.push(currentName);
        }

        pendingName = name;
        pendingItem = _createSurface(name);
        if (!pendingItem)
            return;

        if (!currentItem) {
            currentItem = pendingItem;
            pendingItem = null;
            currentName = name;
            currentItem.visible = true;
            currentItem.opacity = 1;
            currentItem.enter();
            surfaceChanged(currentName);
            return;
        }

        busy = true;
        outgoingItem = currentItem;
        outgoingItem.exit(name);

        pendingItem.visible = true;
        pendingItem.opacity = 0;

        fadeOut.target = outgoingItem;
        fadeOut.restart();
    }

    function back() {
        if (busy)
            return;
        if (history.length > 0) {
            const previous = history.pop();
            open(previous, false);
            return;
        }
        if (currentName !== initialSurfaceName)
            open(initialSurfaceName, false);
    }

    function close() {
        if (busy)
            return;
        if (currentName !== initialSurfaceName) {
            history.length = 0;
            open(initialSurfaceName, false);
        }
    }

    Component.onCompleted: {
        open(initialSurfaceName);
    }
}
