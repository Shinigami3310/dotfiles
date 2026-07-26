import QtQuick
import "../Singletons"

Item {
    id: root

    property var surfaces: ({})
    property string initialSurfaceName: ""
    property string currentName: ""
    property var currentPayload: null

    property bool busy: false

    property string queuedName: ""
    property var queuedPayload: null

    property string pendingName: ""
    property var pendingPayload: null

    property var history: []
    property var cache: ({})

    property Item currentItem: null
    property Item outgoingItem: null
    property Item pendingItem: null

    signal sizeChanged
    signal surfaceChanged(string name)

    clip: true

    implicitWidth: currentItem ? Math.ceil(currentItem.implicitWidth) : 0
    implicitHeight: currentItem ? Math.ceil(currentItem.implicitHeight) : 0

    Item {
        id: stage
        anchors.fill: parent
        clip: true
    }

    Connections {
        target: root.currentItem
        ignoreUnknownSignals: true

        function onSurfaceRequested(newName, payload) {
            root.open(newName, payload);
        }

        function onBackRequested() {
            root.back();
        }

        function onCloseRequested() {
            root.back();
        }

        function onSizeChanged() {
            root.sizeChanged();
        }

        function onFocusRequested() {
            root._focusCurrent();
        }
    }

    Timer {
        id: resizeTimer
        interval: Motion.expand
        repeat: false
        running: false

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
            root.currentPayload = root.pendingPayload;
            root.pendingItem = null;

            root.currentItem.visible = true;
            root.currentItem.opacity = 0;
            root.currentItem.enter(root.currentPayload);
            root._focusCurrent();

            root.sizeChanged();
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

            if (root.queuedName !== "") {
                var nextName = root.queuedName;
                var nextPayload = root.queuedPayload;

                root.queuedName = "";
                root.queuedPayload = null;

                Qt.callLater(function () {
                    root.open(nextName, nextPayload);
                });
            }
        }
    }

    function _spec(name) {
        if (!root.surfaces)
            return null;
        return root.surfaces[name] ? root.surfaces[name] : null;
    }

    function _focusCurrent() {
        if (root.currentItem && root.currentItem.forceActiveFocus)
            root.currentItem.forceActiveFocus();
    }

    function _createSurface(name, payload) {
        var spec = _spec(name);
        if (!spec)
            return null;

        var component = spec.component !== undefined ? spec.component : spec;
        var persistent = spec.persistent === true;
        var wantsKeyboardFocus = spec.wantsKeyboardFocus === true;
        var escapePolicy = spec.escapePolicy !== undefined ? spec.escapePolicy : 1;
        var canGoBack = spec.canGoBack === true;

        if (persistent && root.cache[name]) {
            var cached = root.cache[name];
            cached.parent = stage;
            cached.surfaceName = name;
            cached.active = false;
            cached.payload = payload;
            cached.visible = false;
            cached.opacity = 0;
            return cached;
        }

        var created = component.createObject(stage, {
            "surfaceName": name,
            "active": false,
            "persistent": persistent,
            "wantsKeyboardFocus": wantsKeyboardFocus,
            "escapePolicy": escapePolicy,
            "canGoBack": canGoBack,
            "payload": payload,
            "visible": false,
            "opacity": 0
        });

        if (!created)
            return null;

        if (persistent)
            root.cache[name] = created;

        return created;
    }

    function _releaseOutgoing() {
        if (!root.outgoingItem)
            return;
        var item = root.outgoingItem;
        var name = item.surfaceName;

        if (item.persistent) {
            item.exit(root.pendingName);
            item.active = false;
            item.visible = false;
            item.opacity = 0;
            if (name !== "")
                root.cache[name] = item;
        } else {
            item.destroy();
        }

        root.outgoingItem = null;
    }

    function open(name, payload, pushHistory) {
        if (!name)
            return;
        if (root.busy) {
            if (root.queuedName === name)
                return;
            root.queuedName = name;
            root.queuedPayload = payload;
            return;
        }

        if (root.currentItem && root.currentName === name) {
            root.currentPayload = payload;
            root.currentItem.enter(payload);
            root._focusCurrent();
            return;
        }

        var spec = _spec(name);
        if (!spec)
            return;
        if (pushHistory !== false && root.currentName !== "" && (root.history.length === 0 || root.history[root.history.length - 1] !== root.currentName)) {
            root.history.push(root.currentName);
        }

        root.pendingName = name;
        root.pendingPayload = payload;
        root.pendingItem = root._createSurface(name, payload);

        if (!root.pendingItem)
            return;
        if (!root.currentItem) {
            root.currentItem = root.pendingItem;
            root.pendingItem = null;
            root.currentName = name;
            root.currentPayload = payload;

            root.currentItem.visible = true;
            root.currentItem.opacity = 1;
            root.currentItem.enter(payload);
            root._focusCurrent();
            root.surfaceChanged(root.currentName);
            return;
        }

        root.busy = true;
        root.outgoingItem = root.currentItem;
        root.outgoingItem.exit(name);

        root.pendingItem.visible = true;
        root.pendingItem.opacity = 0;

        fadeOut.target = root.outgoingItem;
        fadeOut.restart();
    }

    function back() {
        if (root.history.length > 0) {
            var previous = root.history.pop();
            root.open(previous, null, false);
            return;
        }

        if (root.initialSurfaceName !== "" && root.currentName !== root.initialSurfaceName)
            root.open(root.initialSurfaceName, null, false);
    }

    function closeCurrent() {
        root.back();
    }

    function _startFadeIn() {
        if (!root.currentItem) {
            root.busy = false;
            return;
        }

        fadeIn.target = root.currentItem;
        fadeIn.restart();
    }

    Component.onCompleted: {
        if (root.initialSurfaceName !== "") {
            Qt.callLater(function () {
                root.open(root.initialSurfaceName, null, false);
            });
        }
    }
}
