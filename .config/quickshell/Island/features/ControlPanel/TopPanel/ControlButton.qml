import QtQuick
import "../../../ui"
import "../../../theme"
import "../"

// Тонкая обёртка над единым ui/IconButton для панели управления.
// Показывает фон-подложку и поддерживает правый клик.
IconButton {
    id: root

    property alias icon: root.source

    showBackground: true
    bgRadius: ControlPanelConfig.buttonRadius
    bgColor: "transparent"
    bgBorderColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.outline_variant
}