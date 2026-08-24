pragma Singleton
import QtQuick

QtObject {
    readonly property int headerSpacing: 8
    readonly property int dotSpacing: 6
    readonly property int dndWidth: 48
    readonly property int dndHeight: 24
    readonly property int buttonRadius: 12
    readonly property int clearButtonSize: 24

    readonly property int cornerMargin: 12
    readonly property int width: 360
    readonly property int padding: 12
    readonly property int radius: 14
    readonly property int borderWidth: 1
    readonly property int columnSpacing: 10

    readonly property int listSpacing: 8
    readonly property int listMaxHeight: 500
    readonly property int maxHistoryItems: 50

    // Пауза перед применением итоговой высоты окна. Покрывает remove
    // (200 мс) + displaced (240 мс), чтобы к моменту ресайза анимации
    // списка завершились и contentHeight был стабилен (иначе «пульсация»).
    readonly property int resizeDebounceInterval: 300
}
