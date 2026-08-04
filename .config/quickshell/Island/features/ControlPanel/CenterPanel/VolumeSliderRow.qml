import QtQuick
import "../../../services/integrations/"

ControlSlider {
    icon: "Volume.png"
    mutedIcon: "VolumeMute.png"
    value: AudioService.volume
    muted: AudioService.muted

    interactiveIcon: true

    onSliderMoved: newVal => AudioService.setVolume(newVal)
    onIconClicked: AudioService.toggleMute()
}
