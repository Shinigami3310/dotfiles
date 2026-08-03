import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

ColumnLayout {
    id: root
    spacing: 8

    Rectangle {
        id: sliderTrack
        Layout.fillWidth: true
        Layout.preferredHeight: 6
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

            property bool dragActive: false
            property real visualProgress: 0

            function calcProgress(mouseX) {
                return Math.max(0, Math.min(1, mouseX / width));
            }

            onPressed: mouse => {
                dragActive = true;
                visualProgress = calcProgress(mouse.x);
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
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: MusicPlayerService.formatTime(MusicPlayerService.position)
            font.pixelSize: 11
            color: Theme.text
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: MusicPlayerService.formatTime(MusicPlayerService.duration)
            font.pixelSize: 11
            color: Theme.text
        }
    }
}
