import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"
import "../../ui"

Item {
    id: root

    property bool isClosing: false

    signal closeRequested

    // Исправление 1: Прячем PlaybackView, если мы в режиме плейлиста
    opacity: MusicPlayerService.isPlaylistMode ? 0.0 : 1.0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.standard
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Item {
            id: trackTextContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Row {
                id: marqueeRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 40

                readonly property bool overflows: text1.implicitWidth > trackTextContainer.width
                property real marqueeX: 0

                x: overflows ? marqueeX : Math.round((trackTextContainer.width - text1.implicitWidth) / 2)

                Text {
                    id: text1
                    text: MusicPlayerService.currentTrackDisplay
                    font {
                        family: Theme.font
                        pixelSize: 18
                        weight: Font.Bold
                    }
                    color: ThemeColor.primary
                }

                Text {
                    id: text2
                    text: text1.text
                    font: text1.font
                    color: text1.color
                    visible: marqueeRow.overflows
                }

                NumberAnimation on marqueeX {
                    running: marqueeRow.overflows && !MusicPlayerService.isPlaylistMode && root.visible && !root.isClosing
                    loops: Animation.Infinite
                    from: 0
                    to: -(text1.implicitWidth + marqueeRow.spacing)
                    duration: Math.max(3000, text1.implicitWidth * 30)
                    easing.type: Easing.Linear
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            IconButton {
                source: "../../assets/icons/Power.png"
                onClicked: {
                    MusicPlayerService.sleep();
                    root.closeRequested();
                }
            }

            HSpacer {}

            RowLayout {
                spacing: 20

                IconButton {
                    source: "../../assets/icons/Previous.png"
                    onClicked: MusicPlayerService.previous()
                }

                IconButton {
                    source: MusicPlayerService.isPlaying ? "../../assets/icons/Stop.png" : "../../assets/icons/Play.png"
                    onClicked: MusicPlayerService.playStop()
                }

                IconButton {
                    source: "../../assets/icons/Next.png"
                    onClicked: MusicPlayerService.next()
                }
            }

            HSpacer {}

            IconButton {
                source: "../../assets/icons/Playlist.png"
                onClicked: MusicPlayerService.togglePlaylistMode()
            }
        }
    }
}
