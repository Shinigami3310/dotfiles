import QtQuick
import "../../theme"

Item {
    id: root

    property int remainingSeconds: 10
    signal backRequested

    readonly property int paddingX: 60
    readonly property int paddingY: 12

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
            pixelSize: 22
            weight: Font.Bold
        }
        color: ThemeColor.primary
        antialiasing: true
        renderType: Text.NativeRendering
    }
}
