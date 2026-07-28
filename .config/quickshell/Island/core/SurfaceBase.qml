import QtQuick
import "../Singletons"

FocusScope {
    id: root

    property string surfaceName: ""
    property bool active: false
    property bool canGoBack: true

    signal surfaceRequested(string newName)
    signal backRequested
    signal closeRequested

    readonly property bool keyboardActive: active && canGoBack

    focus: keyboardActive
    Keys.enabled: keyboardActive

    Timer {
        id: escTimer
        interval: 250
        repeat: false
        onTriggered: backRequested()
    }

    Keys.onEscapePressed: {
        if (!canGoBack)
            return;
        if (escTimer.running) {
            escTimer.stop();
            closeRequested();
        } else
            escTimer.start();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        onClicked: {
            if (canGoBack)
                backRequested();
        }
    }

    function enter() {
        active = true;
    }

    function exit(nextSurfaceName) {
        active = false;
    }
}
