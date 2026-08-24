import QtQuick
import "../../../ui"
import "../"

Slider {
    id: root

    property alias icon: root.iconName
    property alias mutedIcon: root.mutedIconName

    trackWidth: 0
    trackHeight: ControlPanelConfig.sliderTrackHeight
    iconBoxSize: ControlPanelConfig.sliderIconContainerSize
    textWidth: ControlPanelConfig.sliderTextWidth
    textSize: ControlPanelConfig.sliderTextSize
}
