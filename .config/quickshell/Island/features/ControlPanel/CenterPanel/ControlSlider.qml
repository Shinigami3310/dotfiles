import QtQuick
import "../../../ui"
import "../"

// Тонкая обёртка над единым ui/Slider для панели управления.
// Трек растягивается на всю ширину (trackWidth = 0 → Layout.fillWidth).
Slider {
    id: root

    property alias icon: root.iconSource

    trackWidth: 0
    trackHeight: ControlPanelConfig.sliderTrackHeight
    iconBoxSize: ControlPanelConfig.sliderIconContainerSize
    iconSize: ControlPanelConfig.sliderIconSize
    textWidth: ControlPanelConfig.sliderTextWidth
    textSize: ControlPanelConfig.sliderTextSize
}