import QtQuick
import "../../services/Demons/"

ControlSlider {
    icon: "Brightness.png"
    value: BrightnessService.level

    onSliderMoved: newVal => BrightnessService.setLevel(newVal)
}
