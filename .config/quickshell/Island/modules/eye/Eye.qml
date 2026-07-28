import QtQuick
import "../../Singletons"
import "../../services/Demons/"

Item {
    id: root

    property int totalSeconds: 10
    property int remainingSeconds: totalSeconds

    property real paddingX: 60
    property real paddingY: 12

    implicitWidth: timeText.implicitWidth + paddingX * 2
    implicitHeight: timeText.implicitHeight + paddingY * 2

    signal backRequested

    Timer {
        id: countdown
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            if (remainingSeconds > 0) {
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
        text: "00:" + String(remainingSeconds).padStart(2, '0')
        font.family: Theme.font
        font.pixelSize: 22
        font.weight: Font.Bold
        color: Theme.accent
        antialiasing: true
    }
}
