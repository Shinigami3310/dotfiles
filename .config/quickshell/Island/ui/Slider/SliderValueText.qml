import QtQuick
import QtQuick.Layouts
import "../../shared/theme"

Text {
    id: root

    property real value: 0.0
    property bool muted: false
    property real textWidth: 32
    property real textSize: 13

    width: textWidth
    // Жёстко фиксируем Layout-ширину: иначе RowLayout отдаёт значение по
    // implicitWidth, и поле «прыгает» при переходе 5% ↔ 100%.
    Layout.preferredWidth: textWidth
    Layout.minimumWidth: textWidth
    Layout.maximumWidth: textWidth
    horizontalAlignment: Text.AlignRight
    text: Math.round((root.muted ? 0 : root.value) * 100) + "%"
    color: ThemeColor.on_surface
    font {
        family: Theme.font
        pixelSize: textSize
    }
}
