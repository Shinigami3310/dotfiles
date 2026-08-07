import QtQuick
import "../../services"
import "../../theme"

OsdSliderPanel {
    id: root

    Connections {
        target: BrightnessService
        function onLevelChanged() {
            root.bumpIdle();
        }
    }

    slider.value: BrightnessService.level
    slider.iconName: "Brightness.png"
    slider.interactiveIcon: false

    slider.onSliderMoved: requestedValue => BrightnessService.setLevel(requestedValue)
}