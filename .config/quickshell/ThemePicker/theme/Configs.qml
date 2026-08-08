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
    readonly property real spacingRatio: 0.6

    // Скос трапеции — доля высоты карточки. 1.0 = скос по горизонтали равен высоте → ровно 45°
    readonly property real bevelRatio: 1.0

    // Масштаб карточек: центральная > соседние > остальные (остальные — единичный)
    readonly property real scaleCenter: 1.5
    readonly property real scaleNear: 1.0
    readonly property real scaleFar: 1.0

    // Затемнение фона overlay
    readonly property color overlayColor: "#99000000"
}
