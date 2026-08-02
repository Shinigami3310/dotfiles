import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

ColumnLayout {
    id: root
    spacing: 8

    // 0 = Закрыто, 1 = Треки текущего плейлиста, 2 = Список плейлистов
    property int menuState: 0

    // Кнопка Повтора (размещена ВЫШЕ стрелки)
    Image {
        Layout.alignment: Qt.AlignHCenter
        source: MusicPlayerService.repeatTrack ? Qt.resolvedUrl("../../../assets/icons/repeat_on.png") : Qt.resolvedUrl("../../../assets/icons/repeat_off.png")
        sourceSize: Qt.size(20, 20)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            onClicked: MusicPlayerService.toggleRepeat()
        }
    }

    // Стрелка раскрытия меню
    Image {
        Layout.alignment: Qt.AlignHCenter
        source: root.menuState === 0 ? Qt.resolvedUrl("../../../assets/icons/arrow_down.png") : Qt.resolvedUrl("../../../assets/icons/arrow_up.png")
        sourceSize: Qt.size(22, 22)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    root.menuState = (root.menuState === 1) ? 0 : 1;
                } else if (mouse.button === Qt.RightButton) {
                    root.menuState = (root.menuState === 2) ? 0 : 2;
                }
            }
        }
    }

    // Список элементов
    ListView {
        id: expandList
        Layout.fillWidth: true
        Layout.preferredHeight: root.menuState === 0 ? 0 : Math.min(contentHeight, 220)

        Behavior on Layout.preferredHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        clip: true
        spacing: 4

        model: root.menuState === 1 ? MusicPlayerService.playlist : (root.menuState === 2 ? MusicPlayerService.playlistNames : null)

        delegate: Rectangle {
            width: ListView.view.width
            height: 48
            color: itemMouse.containsMouse ? Theme.surface1 : "transparent"
            radius: 8

            MouseArea {
                id: itemMouse
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    if (root.menuState === 1) {
                        MusicPlayerService.loadTrack(index, true);
                    } else if (root.menuState === 2) {
                        MusicPlayerService.setPlaylist(modelData, false);
                        root.menuState = 1; // Возвращаемся в панель треков этого плейлиста
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 10

                // Маленькая обложка слева
                Rectangle {
                    width: 36
                    height: 36
                    radius: 6
                    color: Theme.surface1
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        anchors.fill: parent
                        source: (root.menuState === 1 && modelData.name) ? Qt.resolvedUrl(`${MusicPlayerService.coversPath}/${modelData.name}.png`) : Qt.resolvedUrl("../../../assets/icons/folder.png")
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                // Название трека и группы (для файлов) или название папки (для плейлистов)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: root.menuState === 1 ? modelData.name : modelData
                        color: (root.menuState === 1 && index === MusicPlayerService.currentIndex) || (root.menuState === 2 && modelData === MusicPlayerService.currentPlaylistName) ? Theme.accent : Theme.text
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: root.menuState === 1
                        Layout.fillWidth: true
                        text: MusicPlayerService.playlist[index]?.artist || "Артист"
                        color: Theme.subtext || Theme.text
                        font.pixelSize: 11
                        opacity: 0.7
                        elide: Text.ElideRight
                    }
                }

                // Кнопка быстрого запуска плейлиста справа (только в режиме плейлистов)
                Image {
                    visible: root.menuState === 2
                    source: Qt.resolvedUrl("../../../assets/icons/play_small.png")
                    sourceSize: Qt.size(20, 20)
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        onClicked: {
                            MusicPlayerService.setPlaylist(modelData, true);
                            root.menuState = 1;
                        }
                    }
                }
            }
        }
    }
}
