import QtQuick
import "../../../services/"

ControlSlider {
    icon: "Brightness.png"
    value: BrightnessService.level

    onSliderMoved: newVal => BrightnessService.setLevel(newVal)
}
