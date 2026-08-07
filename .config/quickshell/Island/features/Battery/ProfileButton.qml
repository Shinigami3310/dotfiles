import QtQuick
import "../../ui"
import "../../theme"
import "../../services"

// Тонкая обёртка над единым ui/IconButton для профиля питания.
// Показывает фон-заливку и активную рамку.
IconButton {
    id: root

    required property string profileId
    property alias iconSource: root.source

    showBackground: true
    bgRadius: BatteryConfig.profileBtnRadius
    bgColor: hovered ? ThemeColor.surface_container_high : ThemeColor.surface_container
    bgBorderColor: isActive ? ThemeColor.primary : "transparent"
    bgBorderWidth: isActive ? BatteryConfig.profileActiveBorderWidth : 0

    readonly property bool isActive: BatteryService.activeProfile === profileId

    onClicked: BatteryService.setProfile(root.profileId)
}