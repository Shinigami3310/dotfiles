import QtQuick
import "../../services/integrations"
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
    slider.iconSource: Qt.resolvedUrl("../../assets/icons/Brightness.png")
    slider.interactiveIcon: false

    slider.onRequestValueChange: requestedValue => BrightnessService.setLevel(requestedValue)
}
