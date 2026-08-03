import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

ColumnLayout {
    id: root
    spacing: 16

    property string currentCover: MusicPlayerService.trackCover
    property string currentTitle: MusicPlayerService.trackTitle
    property string currentArtist: MusicPlayerService.trackArtist

    // Слушаем изменения и запускаем анимацию с задержкой, чтобы сгруппировать обновления
    Connections {
        target: MusicPlayerService
        function onTrackTitleChanged() {
            updateTimer.restart();
        }
        function onTrackCoverChanged() {
            updateTimer.restart();
        }
        function onTrackArtistChanged() {
            updateTimer.restart();
        }
    }

    Timer {
        id: updateTimer
        interval: 50
        onTriggered: {
            if (currentTitle !== MusicPlayerService.trackTitle || currentCover !== MusicPlayerService.trackCover) {
                fadeAnim.restart();
            } else if (currentArtist !== MusicPlayerService.trackArtist) {
                currentArtist = MusicPlayerService.trackArtist;
                fadeAnim.restart();
            }
        }
    }

    SequentialAnimation {
        id: fadeAnim
        NumberAnimation {
            target: contentGroup
            property: "opacity"
            to: 0
            duration: 150
            easing.type: Easing.InOutQuad
        }
        ScriptAction {
            script: {
                currentCover = MusicPlayerService.trackCover;
                currentTitle = MusicPlayerService.trackTitle;
                currentArtist = MusicPlayerService.trackArtist;
            }
        }
        NumberAnimation {
            target: contentGroup
            property: "opacity"
            to: 1
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    ColumnLayout {
        id: contentGroup
        Layout.fillWidth: true
        spacing: 16

        // 1. Обложка альбома
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200
            radius: 12
            color: Theme.surface1
            clip: true

            Image {
                anchors.fill: parent
                source: root.currentCover || Qt.resolvedUrl("../../assets/icons/Fallback.png")
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }
        }

        // 2. Название трека (Бегущая строка)
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: titleText.implicitHeight
            clip: true
            Text {
                id: titleText
                text: root.currentTitle
                font.pixelSize: 18
                font.bold: true
                color: Theme.text
                x: fits ? (parent.width - implicitWidth) / 2 : anim.currentX
                readonly property bool fits: implicitWidth <= parent.width

                onTextChanged: anim.currentX = 0 // Сброс позиции при смене трека

                SequentialAnimation {
                    id: anim
                    running: !titleText.fits
                    loops: Animation.Infinite
                    property real currentX: 0
                    PauseAnimation {
                        duration: 1500
                    }
                    NumberAnimation {
                        target: anim
                        property: "currentX"
                        from: 0
                        to: Math.min(0, titleText.parent ? (titleText.parent.width - titleText.implicitWidth) : 0)
                        duration: Math.max(1, (titleText.implicitWidth - (titleText.parent ? titleText.parent.width : 0)) * 15)
                    }
                    PauseAnimation {
                        duration: 1500
                    }
                    NumberAnimation {
                        target: anim
                        property: "currentX"
                        to: 0
                        duration: 0
                    }
                }
            }
        }

        // 3. Исполнитель
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width
            text: root.currentArtist
            font.pixelSize: 14
            color: Theme.text
            opacity: 0.8
            elide: Text.ElideRight
        }
    }
}
