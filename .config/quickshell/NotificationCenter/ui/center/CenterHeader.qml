import QtQuick
import QtQuick.Layouts
import "../../config"
import "../../services"

RowLayout {
    id: root
    property NotificationService service

    signal clearAllRequested

    spacing: 10

    Text {
        text: "Notifications"
        color: Colors.text
        font.pixelSize: 15
        font.bold: true
        Layout.fillWidth: true
    }

    Row {
        spacing: 6
        Layout.alignment: Qt.AlignVCenter

        // Фильтр Low
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: service?.filterLow ? Colors.borderLow : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderLow
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (service)
                        service.filterLow = !service.filterLow;
                }
            }
        }
        // Фильтр Normal
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: service?.filterNormal ? Colors.borderNormal : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderNormal
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (service)
                        service.filterNormal = !service.filterNormal;
                }
            }
        }
        // Фильтр Critical
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: service?.filterCritical ? Colors.borderCritical : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderCritical
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (service)
                        service.filterCritical = !service.filterCritical;
                }
            }
        }
    }

    // Кнопка DND
    Rectangle {
        width: 50
        height: 24
        radius: 12
        color: service?.dndEnabled ? Colors.primary : Colors.surfaceContainer
        Text {
            anchors.centerIn: parent
            text: "DND"
            font.pixelSize: 10
            font.bold: true
            color: service?.dndEnabled ? Colors.surface : Colors.muted
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (service)
                    service.toggleDnd();
            }
        }
    }

    // Кнопка очистки
    Rectangle {
        width: 24
        height: 24
        radius: 12
        color: Colors.surfaceContainer
        Text {
            anchors.centerIn: parent
            text: "🗑"
            font.pixelSize: 12
            color: Colors.text
        }
        MouseArea {
            anchors.fill: parent
            onClicked: clearAllRequested()
        }
    }
}
