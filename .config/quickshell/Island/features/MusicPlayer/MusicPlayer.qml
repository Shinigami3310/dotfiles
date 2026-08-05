import QtQuick
import "../../theme"
import "../../services/integrations"

Item {
    id: root

    implicitWidth: 360
    implicitHeight: 100

    signal closeRequested

    property bool isClosing: true

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
            if (MusicPlayerService.isPlaylistMode) {
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
        anchors.margins: 14
        isClosing: root.isClosing
        onCloseRequested: root.closeRequested()
    }

    PlaylistView {
        id: playlistView
        anchors.fill: parent
    }
}
