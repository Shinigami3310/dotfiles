import QtQuick
import "../../services"
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
    slider.iconSource: Qt.resolvedUrl("../../assets/icons/" + (AudioService.muted ? "VolumeMute.png" : "Volume.png"))
    slider.mutedIcon: Qt.resolvedUrl("../../assets/icons/VolumeMute.png")
    slider.muted: AudioService.muted
    slider.interactiveIcon: true

    slider.onSliderMoved: requestedValue => AudioService.setVolume(requestedValue)
    slider.onIconClicked: {
        AudioService.toggleMute();
        root.bumpIdle();
    }
}