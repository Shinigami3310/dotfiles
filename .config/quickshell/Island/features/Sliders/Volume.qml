import QtQuick
import "../../services/integrations"
import "../../theme"

OsdSliderPanel {
    id: root

    Connections {
        target: AudioService
        function onVolumeChanged() {
            root.bumpIdle();
        }
        function onMutedChanged() {
            root.bumpIdle();
        }
    }

    slider.value: AudioService.muted ? 0.0 : AudioService.volume
    slider.fillColor: AudioService.muted ? Theme.surface2 : Theme.accent
    slider.iconSource: Qt.resolvedUrl("../../assets/icons/" + (AudioService.muted ? "VolumeMute.png" : "Volume.png"))
    slider.iconOpacity: AudioService.muted ? 0.4 : 1.0
    slider.interactiveIcon: true

    slider.onRequestValueChange: requestedValue => AudioService.setVolume(requestedValue)
    slider.onIconClicked: {
        AudioService.toggleMute();
        root.bumpIdle();
    }
}
