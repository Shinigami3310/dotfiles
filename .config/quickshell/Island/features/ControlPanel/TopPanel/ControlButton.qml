import QtQuick
import "../../../ui"
import "../../../shared/theme"
import "../"

IconButton {
    id: root

    property alias icon: root.iconName

    showBackground: true
    bgRadius: ControlPanelConfig.buttonRadius
    bgColor: ThemeColor.transparent
    bgBorderColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.outline_variant
}
