import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

RowLayout {
    id: root
    spacing: 12

    Rectangle {
        id: sliderTrack
        Layout.fillWidth: true
        Layout.preferredHeight: 6
        Layout.alignment: Qt.AlignVCenter
        color: Theme.surface1
        radius: height / 2

        Rectangle {
            height: parent.height
            radius: parent.radius
            color: Theme.accent
            width: parent.width * (MusicPlayerService.duration > 0 ? (sliderMouse.dragActive ? sliderMouse.visualProgress : (MusicPlayerService.position / MusicPlayerService.duration)) : 0)
        }

        MouseArea {
            id: sliderMouse
            anchors.fill: parent
            anchors.margins: -8

            property bool dragActive: false
            property real visualProgress: 0
            property bool wasPlaying: false

            function calcProgress(mouseX) {
                return Math.max(0, Math.min(1, mouseX / width));
            }

            onPressed: mouse => {
                dragActive = true;
                visualProgress = calcProgress(mouse.x);
                wasPlaying = MusicPlayerService.isPlaying;
                MusicPlayerService.pause();
            }

            onPositionChanged: mouse => {
                if (dragActive) {
                    visualProgress = calcProgress(mouse.x);
                }
            }

            onReleased: mouse => {
                visualProgress = calcProgress(mouse.x);
                MusicPlayerService.seek(visualProgress * MusicPlayerService.duration);
                dragActive = false;
                if (wasPlaying) {
                    MusicPlayerService.play();
                }
            }
        }
    }

    Text {
        text: `${MusicPlayerService.formatTime(MusicPlayerService.position)} / ${MusicPlayerService.formatTime(MusicPlayerService.duration)}`
        font.pixelSize: 11
        color: Theme.text
        Layout.alignment: Qt.AlignVCenter
    }
}
