pragma Singleton
import QtQuick

QtObject {
    readonly property int durationInstant: 60    // Тактильное сжатие кнопки (Press)
    readonly property int durationMicro: 100     // Микро-взаимодействия (гашение, колесо)
    readonly property int durationFast: 160      // Hover On, cross-fade иконок, удаление из списка
    readonly property int durationStandard: 200  // Hover Off, появление в списке, вылет уведомления
    readonly property int durationSlow: 240      // Ресайз панелей, отскок кнопки, скрытие уведомления
    readonly property int durationExpand: 400
    readonly property int durationMorph: 200     // Перестроение списков (AnimatedList, MonthHeader)

    // --- 1. Прозрачность и Цвет ---
    readonly property int curveLinear: Easing.Linear
    readonly property int curveOpacityOut: Easing.OutSine  // Исчезновение (быстрое начало)
    readonly property int curveOpacityIn: Easing.InSine    // Появление (медленное начало)

    // --- 2. Масштаб и Тактильность ---
    readonly property int curveScaleHover: Easing.OutCubic
    readonly property int curveScalePress: Easing.InQuad   // Нарастающее вдавливание
    readonly property int curveScaleRelease: Easing.OutBack // Пружинный отскок

    // --- 3. Трансформации Контейнеров ---
    readonly property int curveResize: Easing.InOutQuad
    readonly property int curveContinuous: Easing.OutCubic // Ползунки / непрерывный ввод

    // --- 4. Пространственные перемещения ---
    readonly property int curveMoveIn: Easing.OutCubic     // Появление элемента в списке
    readonly property int curveMoveOut: Easing.InCubic     // Уход (скрытие уведомлений)
    readonly property int curveMoveAlert: Easing.OutExpo   // Агрессивный вылет уведомления
}
