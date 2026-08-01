import QtQuick
import "../../../services"

ControlSlider {
    BrightnessService {
        id: brightnessService
    }
    icon: "Brightness.png"
    value: brightnessService.level
    onSliderMoved: newVal => brightnessService.setLevel(newVal)
}
