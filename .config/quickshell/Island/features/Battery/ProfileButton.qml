import QtQuick
import "../../ui"
import "../../shared/theme"
import "../../services"

IconButton {
    id: root

    required property string profileId
    property alias iconSource: root.iconName

    showBackground: true
    bgRadius: BatteryConfig.profileBtnRadius
    bgColor: hovered ? ThemeColor.surface_container_high : ThemeColor.surface_container
    bgBorderColor: isActive ? ThemeColor.primary : ThemeColor.transparent
    bgBorderWidth: isActive ? BatteryConfig.profileActiveBorderWidth : 0

    readonly property bool isActive: BatteryService.activeProfile === profileId

    onClicked: BatteryService.setProfile(root.profileId)
}
