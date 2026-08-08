import QtQuick
import "../../ui"
import "../../theme"

// OSD-панель: оборачивает ui/Slider и закрывается по таймауту бездействия.
Item {
    id: root

    readonly property int paddingX: UiConfig.osdPaddingX
    readonly property int paddingY: UiConfig.osdPaddingY
    readonly property int idleTimeout: UiConfig.osdIdleTimeout

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
        onSliderMoved: root.bumpIdle()
        onIconClicked: root.bumpIdle()
    }
}
