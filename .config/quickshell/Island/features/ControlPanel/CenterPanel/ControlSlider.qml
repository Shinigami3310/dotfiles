import QtQuick
import "../../../ui"
import "../"

// Обёртка над ui/Slider для панели управления. trackWidth = 0 растягивает
// трек на всю ширину панели — это ключевое отличие от OSD-слайдера,
// где трек фиксированной ширины по центру.
Slider {
    id: root

    property alias icon: root.iconName
    property alias mutedIcon: root.mutedIconName

    trackWidth: 0
    trackHeight: ControlPanelConfig.sliderTrackHeight
    iconBoxSize: ControlPanelConfig.sliderIconContainerSize
    iconSize: ControlPanelConfig.sliderIconSize
    textWidth: ControlPanelConfig.sliderTextWidth
    textSize: ControlPanelConfig.sliderTextSize
}