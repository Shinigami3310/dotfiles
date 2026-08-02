import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

ColumnLayout {
    id: root
    spacing: 12

    property string trackTitle: MusicPlayerService.playlist[MusicPlayerService.currentIndex]?.name || "Загрузка..."
    property string trackArtist: "Исполнитель"
    property string coverUrl: ""

    Connections {
        target: MusicPlayerService
        function onTrackChanged(title, artist, album, cover) {
            root.trackTitle = title;
            root.trackArtist = artist;
            root.coverUrl = cover;
        }
    }

    // 1. Обложка
    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 160
        Layout.preferredHeight: 160
        radius: 12
        color: Theme.surface1
        clip: true

        Image {
            anchors.fill: parent
            source: root.coverUrl || Qt.resolvedUrl("../../../assets/icons/cover_fallback.png")
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }
    }

    // 2. Название трека (Бегущая строка по кругу)
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: titleText.implicitHeight
        clip: true

        Text {
            id: titleText
            text: root.trackTitle
            font.pixelSize: 16
            font.bold: true
            color: Theme.text

            readonly property bool overflow: implicitWidth > parent.width

            x: overflow ? marqueeAnim.currentX : (parent.width - implicitWidth) / 2

            SequentialAnimation {
                id: marqueeAnim
                running: titleText.overflow
                loops: Animation.Infinite
                property real currentX: 0

                PauseAnimation {
                    duration: 1500
                }
                NumberAnimation {
                    target: marqueeAnim
                    property: "currentX"
                    from: 0
                    to: -(titleText.implicitWidth - titleText.parent.width)
                    duration: Math.max(2000, (titleText.implicitWidth - titleText.parent.width) * 30)
                    easing.type: Easing.InOutQuad
                }
                PauseAnimation {
                    duration: 1500
                }
                NumberAnimation {
                    target: marqueeAnim
                    property: "currentX"
                    to: 0
                    duration: Math.max(2000, (titleText.implicitWidth - titleText.parent.width) * 30)
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    // 3. Исполнитель / Группа
    Text {
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: root.trackArtist
        font.pixelSize: 13
        color: Theme.subtext || Theme.text
        elide: Text.ElideRight
        opacity: 0.8
    }
}
