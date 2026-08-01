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

    AudioService {
        id: audioService
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
        target: audioService
        function onVolumeChanged() {
            root.bumpIdle();
        }
        function onMutedChanged() {
            root.bumpIdle();
        }
    }

    Slider {
        id: slider
        anchors.centerIn: parent

        value: audioService.muted ? 0.0 : audioService.volume
        fillColor: audioService.muted ? Theme.surface2 : Theme.accent
        iconSource: Qt.resolvedUrl("../../assets/icons/" + (audioService.muted ? "VolumeMute.png" : "Volume.png"))
        iconOpacity: audioService.muted ? 0.4 : 1.0
        interactiveIcon: true

        // ИСПРАВЛЕНИЕ: Ловим правильный сигнал от дочернего компонента
        onRequestValueChange: val => audioService.setVolume(val)
        onIconClicked: audioService.toggleMute()
        onInteracted: root.bumpIdle()
    }
}
