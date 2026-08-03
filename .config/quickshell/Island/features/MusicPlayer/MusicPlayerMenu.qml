import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../theme"
import "../../services/integrations"

ColumnLayout {
    id: root
    spacing: 8
    property int menuState: 0

    // Кнопка Повтора
    Button {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 36
        implicitHeight: 36
        icon.source: Qt.resolvedUrl("../../assets/icons/Repeat.png")
        icon.color: MusicPlayerService.repeatTrack ? Theme.accent : (pressed ? Theme.accent : Theme.text)
        icon.width: 20
        icon.height: 20
        background: Item {}
        scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
        onClicked: MusicPlayerService.toggleRepeat()
    }

    // Разделитель
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        Layout.topMargin: -4     // подтянет линию вверх, ближе к контролам
        Layout.bottomMargin: -4  // или наоборот
        color: Theme.panelBorder
    }

    // Стрелка меню
    Image {
        Layout.alignment: Qt.AlignHCenter
        source: Qt.resolvedUrl("../../assets/icons/Arrow_down.png")
        sourceSize: Qt.size(22, 22)
        rotation: root.menuState === 0 ? 0 : 180
        Behavior on rotation {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }

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

    // Список
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
                        root.menuState = 1;
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 10
                // Обложка (только для треков)
                Rectangle {
                    visible: root.menuState === 1
                    width: 36
                    height: 36
                    radius: 6
                    color: Theme.surface1
                    clip: true
                    Layout.alignment: Qt.AlignVCenter
                    Image {
                        anchors.fill: parent
                        source: (root.menuState === 1 && modelData.originalName) ? (MusicPlayerService.coversPath + "/" + modelData.originalName + ".png") : ""
                        fillMode: Image.PreserveAspectCrop
                    }
                }

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
                }

                Button {
                    visible: root.menuState === 2
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 32
                    implicitHeight: 32
                    icon.source: Qt.resolvedUrl("../../assets/icons/Play.png")
                    icon.color: Theme.text
                    icon.width: 16
                    icon.height: 16
                    background: Item {}
                    onClicked: {
                        MusicPlayerService.setPlaylist(modelData, true);
                        root.menuState = 1;
                    }
                }
            }
        }
    }
}
