pragma Singleton

import QtQuick

// Константы раскладки и масштабирования карусели.
// Все «магические числа» вынесены сюда для простой настройки.
QtObject {
    // Высота карточки — доля высоты экрана (~1/3)
    readonly property real cardHeightRatio: 0.3

    // Пропорции карточки (ширина / высота)
    readonly property real cardAspect: 1.6

    // Горизонтальный шаг между центрами карточек — доля ширины карточки
    readonly property real spacingRatio: 0.8

    // Скос параллелограмма — доля высоты карточки.
    // Угол наклона грани от горизонтали: bevelRatio = tan(90° - угол).
    // 60° → tan(30°) ≈ 0.577. Меняй это значение для настройки угла.
    readonly property real bevelRatio: 0.7

    // Масштаб: масштабируется только центральная карточка, остальные — единичные
    readonly property real scaleCenter: 1.5

    // Затемнение фона overlay
    readonly property color overlayColor: "#99000000"

    // --- Пути (единый источник правды для QML) ---
    readonly property string wallpaperDir: "/home/Rostislav/Pictures/Wallpapers"
    readonly property string setThemeScriptPath: "/home/Rostislav/.config/quickshell/ThemePicker/scripts/set-theme"
    readonly property string palettePath: "/home/Rostislav/.config/quickshell/colors.json"

    // --- Константы навигации ---
    // Задержка автоповтора при зажатой клавише (мс)
    readonly property int navRepeatDelay: 80

    // --- Константы отрисовки карусели ---
    // Базовый z-индекс карточки и шаг для разрешения конфликтов
    readonly property int zBase: 100
    readonly property int zStep: 10
}
