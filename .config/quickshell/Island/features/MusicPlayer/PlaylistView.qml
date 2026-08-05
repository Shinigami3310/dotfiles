import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

Rectangle {
    id: root

    color: ThemeColor.surface
    radius: 24
    visible: opacity > 0
    opacity: MusicPlayerService.isPlaylistMode ? 1.0 : 0.0

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.standard
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        IconButton {
            source: "../../assets/icons/PreviousPlaylist.png"
            onClicked: MusicPlayerService.previous()
        }

        Text {
            text: MusicPlayerService.currentPlaylistName
            font {
                family: Theme.font
                pixelSize: 18
                weight: Font.Bold
            }
            color: ThemeColor.primary
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        IconButton {
            source: "../../assets/icons/NextPlaylist.png"
            onClicked: MusicPlayerService.next()
        }
    }
}
