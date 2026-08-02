import QtQuick
import "../../theme"

Item {
    id: root

    property bool active: true
    property alias slider: innerSlider
    signal closeRequested

    implicitWidth: innerSlider.implicitWidth + Configs.osdPaddingX
    implicitHeight: innerSlider.implicitHeight + Configs.osdPaddingY

    Timer {
        id: idleTimer
        interval: Configs.osdIdleTimeout
        running: root.active
        repeat: false
        onTriggered: root.closeRequested()
    }

    function bumpIdle() {
        if (root.active)
            idleTimer.restart();
    }

    onActiveChanged: {
        if (root.active)
            bumpIdle();
    }

    Slider {
        id: innerSlider
        anchors.centerIn: parent
        onInteracted: root.bumpIdle()
    }
}
