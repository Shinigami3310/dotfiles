pragma Singleton
import QtQuick

QtObject {
    readonly property int cornerMargin: 12
    readonly property int width: 320
    readonly property int spacing: 8
    readonly property int timeoutLowMs: 3000
    readonly property int timeoutNormalMs: 5000
    readonly property int maxVisible: 3
    readonly property int maxHeight: 600
}
