import QtQuick
import QtQuick.Layouts
import "../../theme"

Rectangle {
    id: root

    width: 340
    implicitHeight: mainLayout.implicitHeight + (mainLayout.anchors.margins * 2)
    implicitWidth: 340

    color: Theme.surface
    radius: 16

    border.color: Theme.panelBorder
    border.width: 1

    ColumnLayout {
        id: mainLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 14

        // 1. Верхняя часть (Обложка, название, артист)
        MusicPlayerHeader {
            Layout.fillWidth: true
        }

        // 2. Слайдер времени
        MusicPlayerSlider {
            Layout.fillWidth: true
        }

        // 3. Кнопки управления (Назад, Stop/Play, Вперед)
        MusicPlayerControls {
            Layout.fillWidth: true
        }

        // 4. Кнопка повтора + Стрелка и Меню списка треков/плейлистов
        MusicPlayerMenu {
            Layout.fillWidth: true
        }
    }
}
