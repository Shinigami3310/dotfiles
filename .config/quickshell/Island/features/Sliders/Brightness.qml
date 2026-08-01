import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"

Item {
    id: root

    property bool active: true
    signal closeRequested

    implicitWidth: slider.implicitWidth + 32
    implicitHeight: slider.implicitHeight + 24

    BrightnessService {
        id: brightnessService
    }

    Timer {
        id: idleTimer
        interval: 3000
        running: root.active
        onTriggered: root.closeRequested()
    }

    function bumpIdle() {
        if (root.active)
            idleTimer.restart();
    }

    onActiveChanged: {
        if (active)
            bumpIdle();
    }

    Connections {
        target: brightnessService
        function onLevelChanged() {
            root.bumpIdle();
        }
    }

    Slider {
        id: slider
        anchors.centerIn: parent

        value: brightnessService.level
        fillColor: Theme.accent
        iconSource: Qt.resolvedUrl("../../assets/icons/Brightness.png")
        interactiveIcon: false

        // ИСПРАВЛЕНИЕ: Ловим правильный сигнал от дочернего компонента
        onRequestValueChange: val => brightnessService.setLevel(val)
        onInteracted: root.bumpIdle()
    }
}
