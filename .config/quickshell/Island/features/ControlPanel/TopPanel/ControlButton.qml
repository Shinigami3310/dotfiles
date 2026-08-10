import QtQuick
import "../../../ui"
import "../../../shared/theme"
import "../"

// Тонкая обёртка над единым ui/IconButton для панели управления.
// Показывает фон-подложку и поддерживает правый клик.
IconButton {
    id: root

    property alias icon: root.iconName

    showBackground: true
    bgRadius: ControlPanelConfig.buttonRadius
    bgColor: ThemeColor.transparent
    bgBorderColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.outline_variant
}