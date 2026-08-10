import QtQuick
import QtQuick.Layouts
import "../../config"
import "../../services"
import "../common"

RowLayout {
    id: root
    property NotificationService service

    signal clearAllRequested

    spacing: 10

    Text {
        text: Constants.labelNotifications
        color: Colors.text
        font.pixelSize: Constants.fontLarge
        font.bold: true
        Layout.fillWidth: true
    }

    Row {
        spacing: 6
        Layout.alignment: Qt.AlignVCenter

        FilterDot {
            active: service?.filterLow ?? false
            dotColor: Colors.borderLow
            onClicked: if (service) service.filterLow = !service.filterLow
        }
        FilterDot {
            active: service?.filterNormal ?? false
            dotColor: Colors.borderNormal
            onClicked: if (service) service.filterNormal = !service.filterNormal
        }
        FilterDot {
            active: service?.filterCritical ?? false
            dotColor: Colors.borderCritical
            onClicked: if (service) service.filterCritical = !service.filterCritical
        }
    }

    // Кнопка DND
    Pressable {
        width: 50
        height: 24
        onClicked: if (service) service.toggleDnd()

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: service?.dndEnabled ? Colors.primary : Colors.surfaceContainer
            Text {
                anchors.centerIn: parent
                text: Constants.labelDnd
                font.pixelSize: Constants.fontTiny
                font.bold: true
                color: service?.dndEnabled ? Colors.surface : Colors.muted
            }
        }
    }

    // Кнопка очистки
    Pressable {
        width: 24
        height: 24
        onClicked: clearAllRequested()

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Colors.surfaceContainer
            Text {
                anchors.centerIn: parent
                text: Constants.labelClear
                font.pixelSize: Constants.fontMedium
                color: Colors.text
            }
        }
    }
}