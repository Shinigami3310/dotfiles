import QtQuick
import "../../theme"

Item {
    id: root

    // Локальные конфиги без префиксов
    readonly property int paddingX: 20
    readonly property int paddingY: 12
    readonly property int idleTimeout: 2500

    property bool active: true
    property alias slider: innerSlider
    signal closeRequested

    implicitWidth: innerSlider.implicitWidth + paddingX * 2
    implicitHeight: innerSlider.implicitHeight + paddingY * 2

    Timer {
        id: idleTimer
        interval: idleTimeout
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
