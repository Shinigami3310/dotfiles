import QtQuick
import "../../../services"

ControlSlider {
    AudioService {
        id: audioService
    }
    icon: "Volume.png"
    mutedIcon: "VolumeMute.png"
    value: audioService.volume
    muted: audioService.muted

    onSliderMoved: newVal => audioService.setVolume(newVal)
    onIconClicked: audioService.toggleMute()
}
