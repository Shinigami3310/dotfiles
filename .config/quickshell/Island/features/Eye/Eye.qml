import QtQuick
import "../../shared/theme"
import "."

Item {
    id: root

    property int remainingSeconds: EyeConfig.countdownSeconds
    signal backRequested

    readonly property int paddingX: EyeConfig.paddingX
    readonly property int paddingY: EyeConfig.paddingY

    implicitWidth: timeText.implicitWidth + (paddingX * 2)
    implicitHeight: timeText.implicitHeight + (paddingY * 2)

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            root.remainingSeconds--;
            if (root.remainingSeconds <= 0) {
                stop();
                root.backRequested();
            }
        }
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: `00:${String(remainingSeconds).padStart(2, '0')}`
        font {
            family: Theme.font
            pixelSize: EyeConfig.textPixelSize
            weight: Font.Bold
        }
        color: ThemeColor.primary
        antialiasing: true
        renderType: Text.NativeRendering
    }
}
