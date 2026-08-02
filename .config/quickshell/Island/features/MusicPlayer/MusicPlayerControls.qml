import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

RowLayout {
    id: root
    spacing: 28
    Layout.alignment: Qt.AlignHCenter

    // Кнопка Назад
    Image {
        source: Qt.resolvedUrl("../../../assets/icons/prev.png")
        sourceSize: Qt.size(24, 24)
        Layout.alignment: Qt.AlignVCenter

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            onClicked: MusicPlayerService.previous()
        }
    }

    // Кнопка Stop / Play
    Rectangle {
        width: 48
        height: 48
        radius: 24
        color: Theme.accent
        Layout.alignment: Qt.AlignVCenter

        Image {
            anchors.centerIn: parent
            source: MusicPlayerService.isPlaying ? Qt.resolvedUrl("../../../assets/icons/pause.png") : Qt.resolvedUrl("../../../assets/icons/play.png")
            sourceSize: Qt.size(24, 24)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: MusicPlayerService.togglePlay()
        }
    }

    // Кнопка Вперед
    Image {
        source: Qt.resolvedUrl("../../../assets/icons/next.png")
        sourceSize: Qt.size(24, 24)
        Layout.alignment: Qt.AlignVCenter

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            onClicked: MusicPlayerService.next()
        }
    }
}
