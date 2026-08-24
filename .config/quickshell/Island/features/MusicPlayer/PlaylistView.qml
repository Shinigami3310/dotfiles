import QtQuick
import QtQuick.Layouts
import "../../shared/theme"
import "../../services"
import "../../ui"

Rectangle {
    id: root

    color: ThemeColor.surface
    radius: 24
    visible: opacity > 0
    opacity: MusicPlayerService.isPlaylistMode ? 1.0 : 0.0

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.durationStandard
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: MusicPlayerConfig.playlistMargin
        spacing: MusicPlayerConfig.playlistSpacing

        IconButton {
            iconName: "PreviousPlaylist.png"
            onClicked: MusicPlayerService.previous()
        }

        Text {
            text: MusicPlayerService.currentPlaylistName
            font {
                family: Theme.font
                pixelSize: MusicPlayerConfig.playlistTextSize
                weight: Font.Bold
            }
            color: ThemeColor.primary
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        IconButton {
            iconName: "NextPlaylist.png"
            onClicked: MusicPlayerService.next()
        }
    }
}
