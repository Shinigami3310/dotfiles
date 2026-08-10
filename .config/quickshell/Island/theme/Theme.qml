pragma Singleton
import QtQuick

// Глобальные визуальные константы: шрифт и единые масштабы жестов hover/pressed.
// Бывший Configs.qml объединён сюда: оба файла были крошечными и всегда использовались вместе.
QtObject {
    readonly property string font: "JetBrains Mono"

    property real scaleHover: 1.1
    property real scalePressed: 0.9
}