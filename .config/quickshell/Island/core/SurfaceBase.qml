import QtQuick

FocusScope {
    id: root

    property string surfaceName: ""
    property bool active: false
    property bool canGoBack: true
    property string backTarget: ""

    signal surfaceRequested(string name)
    signal backRequested
    signal closeRequested

    readonly property bool requiresKeyboard: active && canGoBack

    focus: requiresKeyboard
    Keys.enabled: requiresKeyboard

    Keys.onEscapePressed: event => {
        if (canGoBack) {
            closeRequested();
            event.accepted = true;
        }
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: {
            if (!canGoBack)
                return;
            if (root.backTarget !== "")
                root.surfaceRequested(root.backTarget)
            else
                root.backRequested()
        }
    }

    function enter() {
        active = true;
    }
    function exit(nextSurfaceName: string) {
        active = false;
    }
}
