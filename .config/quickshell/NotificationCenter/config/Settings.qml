pragma Singleton
import QtQuick

QtObject {
    readonly property int toastMaxVisible: 3
    readonly property int toastTimeoutLowMs: 3000
    readonly property int toastTimeoutNormalMs: 5000

    readonly property bool allowCriticalInDnd: true

    readonly property int cornerMargin: 16
    readonly property int toastSpacing: 10

    readonly property int centerWidth: 420
    readonly property int centerMaxHeight: 520
    readonly property int maxHistoryItems: 50

    // Геометрия UI (ранее захардкожена в компонентах)
    readonly property int toastWidth: 360
    readonly property int listMaxHeight: 340
    readonly property int centerPadding: 12
    readonly property int itemPadding: 10
}