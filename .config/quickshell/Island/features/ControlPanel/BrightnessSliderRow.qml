import QtQuick
import "../../services/integrations"

ControlSlider {
    icon: "Brightness.png"
    value: BrightnessService.level

    onSliderMoved: newVal => BrightnessService.setLevel(newVal)
}
