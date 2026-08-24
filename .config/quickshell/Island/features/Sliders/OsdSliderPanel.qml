import QtQuick
import "../../ui"
import "../../shared/theme"

Item {
    id: root

    readonly property int paddingX: UiConfig.osdPaddingX
    readonly property int paddingY: UiConfig.osdPaddingY
    readonly property int idleTimeout: UiConfig.osdIdleTimeout

    property bool active: true
    property alias slider: innerSlider
    signal closeRequested

    readonly property bool hovered: hoverHandler.hovered

    implicitWidth: innerSlider.implicitWidth + paddingX * 2
    implicitHeight: innerSlider.implicitHeight + paddingY * 2

    Timer {
        id: idleTimer
        interval: idleTimeout
        running: root.active && !root.hovered
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

    HoverHandler {
        id: hoverHandler
    }

    Slider {
        id: innerSlider
        anchors.centerIn: parent
        onSliderMoved: root.bumpIdle()
        onIconClicked: root.bumpIdle()
    }
}
