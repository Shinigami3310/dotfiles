import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../theme"
import "../../services/integrations"

RowLayout {
    id: root
    spacing: 18
    Layout.alignment: Qt.AlignHCenter

    signal closeRequested

    // Свойства для симуляции нажатий с клавиатуры
    property bool simPrev: false
    property bool simPlay: false
    property bool simNext: false

    // Свойство для защиты от мигания иконки при быстром переключении треков
    property bool visuallyPlaying: MusicPlayerService.isPlaying

    Timer {
        id: playFlickerTimer
        interval: 150
        onTriggered: visuallyPlaying = MusicPlayerService.isPlaying
    }

    Connections {
        target: MusicPlayerService
        function onIsPlayingChanged() {
            if (MusicPlayerService.isPlaying) {
                playFlickerTimer.stop();
                visuallyPlaying = true;
            } else {
                playFlickerTimer.restart();
            }
        }
    }

    Timer {
        id: simResetTimer
        interval: 150
        onTriggered: {
            simPrev = false;
            simPlay = false;
            simNext = false;
        }
    }

    function triggerPrevious() {
        simPrev = true;
        simResetTimer.restart();
        MusicPlayerService.previous();
    }

    function triggerPlay() {
        simPlay = true;
        simResetTimer.restart();
        MusicPlayerService.togglePlay();
    }

    function triggerNext() {
        simNext = true;
        simResetTimer.restart();
        MusicPlayerService.next();
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 44
        implicitHeight: 44
        icon.source: Qt.resolvedUrl("../../assets/icons/Previous.png")
        icon.color: pressed ? Theme.accent : Theme.text
        icon.width: 24
        icon.height: 24
        background: Item {}

        scale: (pressed || simPrev) ? 0.9 : (hovered ? 1.1 : 1.0)
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        onClicked: MusicPlayerService.previous()
    }

    Item {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 56
        implicitHeight: 56

        scale: (playMouseArea.pressed || simPlay) ? 0.9 : (playMouseArea.containsMouse ? 1.1 : 1.0)
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        Image {
            anchors.centerIn: parent
            width: 28
            height: 28
            source: visuallyPlaying ? Qt.resolvedUrl("../../assets/icons/Stop.png") : Qt.resolvedUrl("../../assets/icons/Play.png")
        }

        MouseArea {
            id: playMouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    MusicPlayerService.togglePlay();
                } else if (mouse.button === Qt.RightButton) {
                    MusicPlayerService.sleep();
                    root.closeRequested();
                }
            }
        }
    }

    Button {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 44
        implicitHeight: 44
        icon.source: Qt.resolvedUrl("../../assets/icons/Next.png")
        icon.color: pressed ? Theme.accent : Theme.text
        icon.width: 24
        icon.height: 24
        background: Item {}

        scale: (pressed || simNext) ? 0.9 : (hovered ? 1.1 : 1.0)
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        onClicked: MusicPlayerService.next()
    }
}
