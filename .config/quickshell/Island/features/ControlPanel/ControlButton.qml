import QtQuick
import QtQuick.Effects // Нужен для окрашивания SVG под цвета темы (Qt 6)
import "../../Singletons/"

Item {
    id: root

    property string icon: "" // Теперь путь к файлу относительно assets/icons/
    property string text: ""
    property bool active: false
    property bool enableRightClick: false

    signal clicked
    signal rightClicked

    implicitWidth: 70
    implicitHeight: 64

    Rectangle {
        id: bg

        anchors.fill: parent
        radius: 12
        color: root.active ? Theme.accent : Theme.surface1
        border.color: mouseArea.containsMouse ? Theme.accentSoft : Theme.panelBorder
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 4

            // Изображение иконки вместо текста
            Image {
                id: iconImg
                anchors.horizontalCenter: parent.horizontalCenter
                width: 22
                height: 22
                source: root.icon !== "" ? Qt.resolvedUrl("../../assets/icons/" + root.icon) : ""
                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.text
                font.family: Theme.font
                font.pixelSize: 11
                color: root.active ? Theme.accentText : Theme.textMuted
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: root.enableRightClick ? (Qt.LeftButton | Qt.RightButton) : Qt.LeftButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                root.clicked();
            } else if (mouse.button === Qt.RightButton) {
                root.rightClicked();
            }
        }
    }
}
