import QtQuick
import "../theme"

FocusScope {
    id: root

    property string surfaceName: ""
    property bool active: false
    property bool canGoBack: true

    signal surfaceRequested(string name)
    signal backRequested
    signal closeRequested

    readonly property bool keyboardActive: active && canGoBack

    focus: keyboardActive
    Keys.enabled: keyboardActive

    Keys.onEscapePressed: if (canGoBack)
        closeRequested()

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: if (canGoBack)
            backRequested()
    }

    function enter() {
        active = true;
    }
    function exit(nextSurfaceName) {
        active = false;
    }
}
