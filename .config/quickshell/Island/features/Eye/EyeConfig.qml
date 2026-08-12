pragma Singleton
import QtQuick

// Конфигурация eye-reminder: длительность и геометрия.
QtObject {
    // Длительность напоминания (секунды)
    readonly property int countdownSeconds: 10

    // Геометрия поверхности (отступы и размер шрифта)
    readonly property int paddingX: 60
    readonly property int paddingY: 12
    readonly property int textPixelSize: 22
}