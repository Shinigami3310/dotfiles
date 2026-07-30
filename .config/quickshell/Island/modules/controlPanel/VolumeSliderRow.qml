import QtQuick
import "../../services/Demons/"

ControlSlider {
    icon: "Volume.png"
    mutedIcon: "VolumeMute.png"
    value: AudioService.volume
    muted: AudioService.muted

    onSliderMoved: newVal => AudioService.setVolume(newVal)
    onIconClicked: AudioService.toggleMute()
}
