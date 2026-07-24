import QtQuick

Item {
    id: root

    property bool expanded: false
    property Component collapsedComponent
    property Component expandedComponent

    property int fadeDuration: 140
    property int resizeDuration: 220

    property bool _shownExpanded: false
    property bool _pendingExpanded: false
    property bool _animating: false

    clip: true

    Loader {
        id: collapsedLoader
        anchors.centerIn: parent
        sourceComponent: root.collapsedComponent

        opacity: 1
        visible: opacity > 0

        onLoaded: root._syncWhenReady()
    }

    Loader {
        id: expandedLoader
        anchors.centerIn: parent
        sourceComponent: root.expandedComponent

        opacity: 0
        visible: opacity > 0

        onLoaded: root._syncWhenReady()
    }

    SequentialAnimation {
        id: transition

        PropertyAnimation {
            id: fadeOut
            property: "opacity"
            duration: root.fadeDuration
            easing.type: Easing.InOutQuad
        }

        ParallelAnimation {
            PropertyAnimation {
                id: widthAnim
                target: root
                property: "width"
                duration: root.resizeDuration
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                id: heightAnim
                target: root
                property: "height"
                duration: root.resizeDuration
                easing.type: Easing.InOutQuad
            }
        }

        PropertyAnimation {
            id: fadeIn
            property: "opacity"
            duration: root.fadeDuration
            easing.type: Easing.InOutQuad
        }

        ScriptAction {
            script: {
                root._shownExpanded = root._pendingExpanded;
                root._animating = false;

                if (root._pendingExpanded !== root.expanded)
                    Qt.callLater(root._startTransition);
            }
        }
    }

    function _loaderFor(state) {
        return state ? expandedLoader : collapsedLoader;
    }

    function _measure(state) {
        const item = _loaderFor(state).item;
        return {
            w: item ? item.implicitWidth : 0,
            h: item ? item.implicitHeight : 0
        };
    }

    function _syncInstant(state) {
        const size = _measure(state);

        root._shownExpanded = state;
        root._pendingExpanded = state;

        root.width = size.w;
        root.height = size.h;

        collapsedLoader.opacity = state ? 0 : 1;
        expandedLoader.opacity = state ? 1 : 0;
    }

    function _syncWhenReady() {
        if (!collapsedLoader.item || !expandedLoader.item)
            return;
        if (!root._animating)
            _syncInstant(root._shownExpanded);
    }

    function _startTransition() {
        if (!collapsedLoader.item || !expandedLoader.item) {
            root._syncWhenReady();
            return;
        }

        if (root._pendingExpanded === root._shownExpanded) {
            _syncInstant(root._shownExpanded);
            return;
        }

        if (root._animating)
            return;
        const fromLoader = _loaderFor(root._shownExpanded);
        const toLoader = _loaderFor(root._pendingExpanded);
        const target = _measure(root._pendingExpanded);

        root._animating = true;
        transition.stop();

        fadeOut.target = fromLoader;
        fadeOut.to = 0;

        widthAnim.to = target.w;
        heightAnim.to = target.h;

        fadeIn.target = toLoader;
        fadeIn.to = 1;

        transition.start();
    }

    onExpandedChanged: {
        root._pendingExpanded = expanded;
        root._startTransition();
    }

    Component.onCompleted: {
        root._shownExpanded = root.expanded;
        root._pendingExpanded = root.expanded;
        Qt.callLater(root._syncWhenReady);
    }
}
