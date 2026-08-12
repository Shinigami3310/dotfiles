pragma Singleton
import QtQuick

// Конфигурация стартового виджета HomeClock (часы на острове).
QtObject {
    // Отступы поверхности (px)
    readonly property int paddingX: 40
    readonly property int paddingY: 12

    // Размер шрифта часов (px)
    readonly property int textPixelSize: 18
}