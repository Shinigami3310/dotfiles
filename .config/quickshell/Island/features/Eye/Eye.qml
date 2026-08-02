import QtQuick
import "../../theme"

Item {
    id: root

    property int remainingSeconds: Configs.eyeSurfaceDuration
    signal backRequested

    implicitWidth: timeText.implicitWidth + (Configs.eyePaddingX * 2)
    implicitHeight: timeText.implicitHeight + (Configs.eyePaddingY * 2)

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            if (remainingSeconds > 1) {
                remainingSeconds--;
            } else {
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
            pixelSize: Configs.eyeTextSize
            weight: Font.Bold
        }
        color: Theme.accent
        antialiasing: true
    }
}
