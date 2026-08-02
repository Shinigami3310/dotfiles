import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations" // Укажите актуальный путь к папке синглтонов

Item {
    id: root

    property bool active: true
    signal closeRequested

    implicitWidth: slider.implicitWidth + Configs.osdPaddingX
    implicitHeight: slider.implicitHeight + Configs.osdPaddingY

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

    Connections {
        target: AudioService

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

        value: AudioService.muted ? 0.0 : AudioService.volume
        fillColor: AudioService.muted ? Theme.surface2 : Theme.accent
        iconSource: Qt.resolvedUrl("../../assets/icons/" + (AudioService.muted ? "VolumeMute.png" : "Volume.png"))
        iconOpacity: AudioService.muted ? 0.4 : 1.0
        interactiveIcon: true

        onRequestValueChange: function (requestedValue) {
            AudioService.setVolume(requestedValue);
        }

        onIconClicked: {
            AudioService.toggleMute();
            root.bumpIdle();
        }

        onInteracted: root.bumpIdle()
    }
}
