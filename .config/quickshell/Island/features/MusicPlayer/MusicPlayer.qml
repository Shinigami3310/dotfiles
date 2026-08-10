import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    implicitWidth: MusicPlayerConfig.surfaceWidth
    implicitHeight: MusicPlayerConfig.surfaceHeight

    signal closeRequested

    property bool isClosing: false

    focus: true

    Component.onCompleted: {
        MusicPlayerService.wakeUp();
        root.forceActiveFocus();
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Space) {
            MusicPlayerService.playStop();
            event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
            MusicPlayerService.previous();
            event.accepted = true;
        } else if (event.key === Qt.Key_Right) {
            MusicPlayerService.next();
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            MusicPlayerService.confirmSelection();
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            if (MusicPlayerService.isPlaylistMode && MusicPlayerService.tracks.length > 0) {
                MusicPlayerService.cancelSelection();
            } else {
                root.closeRequested();
            }
            event.accepted = true;
        }
    }

    PlaybackView {
        id: playbackView
        anchors.fill: parent
        anchors.margins: MusicPlayerConfig.surfaceMargin
        isClosing: root.isClosing
        onCloseRequested: root.closeRequested()
    }

    PlaylistView {
        id: playlistView
        anchors.fill: parent
    }
}
