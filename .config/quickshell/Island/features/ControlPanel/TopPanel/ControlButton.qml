import QtQuick
import Qt5Compat.GraphicalEffects
import "../../../theme"

Item {
    id: root

    property string icon: ""
    property bool active: false
    property bool enableRightClick: false

    signal clicked
    signal rightClicked

    // Делаем кнопку квадратной, так как текст убран
    implicitWidth: 64
    implicitHeight: 64

    Rectangle {
        id: bg
        // Центрируем Rectangle внутри Item, чтобы scale работал ровно от центра
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 12

        // Граница видна по умолчанию
        border.color: Theme.panelBorder
        border.width: 1

        // Светлый фон при наведении (при нажатии остается таким же)
        color: mouseArea.containsMouse ? Theme.surface2 : Theme.surface1

        // Увеличение 1.05 при наведении
        scale: mouseArea.containsMouse ? 1.05 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack // OutBack дает приятный эффект легкой отдачи
            }
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: 24
            height: 24
            sourceSize: Qt.size(width * 2, height * 2) // Для четкости на HighDPI
            source: root.icon !== "" ? Qt.resolvedUrl("../../../assets/icons/" + root.icon) : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: false // Скрываем оригинальное изображение, так как работает ColorOverlay
        }

        ColorOverlay {
            anchors.fill: iconImage
            source: iconImage
            // Цвет иконки меняется при нажатии (pressed) или при активности (active)
            color: (mouseArea.pressed || root.active) ? Theme.accent : Theme.textMuted
            antialiasing: true

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    // MouseArea вынесена за пределы Rectangle, чтобы зона клика
    // оставалась статической (64x64) и не "убегала" при увеличении scale
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: root.enableRightClick ? (Qt.LeftButton | Qt.RightButton) : Qt.LeftButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.clicked();
            else if (mouse.button === Qt.RightButton)
                root.rightClicked();
        }
    }
}
