import QtQuick
import QtQuick.Layouts
import "../../shared/theme"
import "../../services"
import "../../ui"

Item {
    id: root

    property bool isClosing: false

    signal closeRequested

    opacity: MusicPlayerService.isPlaylistMode ? 0.0 : 1.0
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.durationStandard
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: MusicPlayerConfig.playbackSpacing

        Item {
            id: trackTextContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Row {
                id: marqueeRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: MusicPlayerConfig.marqueeSpacing

                readonly property bool overflows: text1.implicitWidth > trackTextContainer.width
                property real marqueeX: 0

                x: overflows ? marqueeX : Math.round((trackTextContainer.width - text1.implicitWidth) / 2)

                Text {
                    id: text1
                    text: MusicPlayerService.currentTrackDisplay
                    font {
                        family: Theme.font
                        pixelSize: MusicPlayerConfig.trackTextSize
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
                    running: marqueeRow.overflows && text1.implicitWidth > 0 && !MusicPlayerService.isPlaylistMode && root.visible && !root.isClosing
                    loops: Animation.Infinite
                    from: 0
                    to: -(text1.implicitWidth + marqueeRow.spacing)
                    duration: Math.max(MusicPlayerConfig.marqueeMinDuration, text1.implicitWidth * MusicPlayerConfig.marqueeDurationPerPixel)
                    easing.type: Motion.curveLinear
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: MusicPlayerConfig.playbackSpacing

            IconButton {
                iconName: "Power.png"
                onClicked: {
                    MusicPlayerService.sleep();
                    root.closeRequested();
                }
            }

            Item { Layout.preferredWidth: MusicPlayerConfig.playbackGroupGap }

            IconButton {
                iconName: "Previous.png"
                onClicked: MusicPlayerService.previous()
            }

            IconButton {
                iconName: MusicPlayerService.isPlaying ? "Stop.png" : "Play.png"
                onClicked: MusicPlayerService.playStop()
            }

            IconButton {
                iconName: "Next.png"
                onClicked: MusicPlayerService.next()
            }

            Item { Layout.preferredWidth: MusicPlayerConfig.playbackGroupGap }

            IconButton {
                iconName: "Playlist.png"
                onClicked: MusicPlayerService.togglePlaylistMode()
            }
        }
    }
}
