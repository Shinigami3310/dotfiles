import QtQuick
import "../../theme"

// Процентное значение слайдера. Вынос в отдельный компонент нужен, чтобы
// размер/шрифт были едиными между OSD и панелью управления — иначе текст
// «прыгает» при переходе между ними.
Text {
    id: root

    property real value: 0.0
    property bool muted: false
    property real textWidth: 32
    property real textSize: 13

    width: textWidth
    horizontalAlignment: Text.AlignRight
    text: Math.round((root.muted ? 0 : root.value) * 100) + "%"
    color: ThemeColor.on_surface
    font {
        family: Theme.font
        pixelSize: textSize
    }
}