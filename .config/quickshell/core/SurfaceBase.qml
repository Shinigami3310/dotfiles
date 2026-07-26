import QtQuick
import "../Singletons"

FocusScope {
    id: root

    readonly property int escapeIgnore: 0
    readonly property int escapeBack: 1
    readonly property int escapeClose: 2

    property string surfaceName: ""
    property bool active: false
    property bool persistent: false
    property bool wantsKeyboardFocus: false
    property int escapePolicy: escapeBack
    property bool canGoBack: false
    property var payload: null

    signal surfaceRequested(string newName, var payload)
    signal backRequested
    signal closeRequested
    signal sizeChanged
    signal focusRequested

    focus: active && wantsKeyboardFocus
    Keys.enabled: active && wantsKeyboardFocus

    Keys.onEscapePressed: {
        if (escapePolicy === escapeIgnore)
            return;
        if (escapePolicy === escapeBack || canGoBack) {
            backRequested();
            return;
        }

        closeRequested();
    }

    onImplicitWidthChanged: sizeChanged()
    onImplicitHeightChanged: sizeChanged()

    function enter(newPayload) {
        payload = newPayload;
        active = true;

        if (wantsKeyboardFocus) {
            focusRequested();
            forceActiveFocus();
        }
    }

    function exit(nextSurfaceName) {
        active = false;
    }

    function reset() {
        payload = null;
        canGoBack = false;
    }
}
