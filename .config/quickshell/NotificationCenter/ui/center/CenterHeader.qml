import QtQuick
import QtQuick.Layouts
import "../center"
import "../../config"
import "../../services"
import "../common"

RowLayout {
    id: root
    property NotificationService service

    signal clearAllRequested

    spacing: CenterConfig.headerSpacing

    Text {
        text: Constants.labelNotifications
        color: Colors.text
        font.family: Constants.fontFamily
        font.pixelSize: Constants.fontLarge
        font.bold: true
        Layout.fillWidth: true
    }

    Row {
        spacing: CenterConfig.dotSpacing
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

    Pressable {
        width: CenterConfig.dndWidth
        height: CenterConfig.dndHeight
        onClicked: if (service) service.toggleDnd()

        Rectangle {
            anchors.fill: parent
            radius: CenterConfig.buttonRadius
            color: service?.dndEnabled ? Colors.primary : Colors.surfaceContainer
            Text {
                anchors.centerIn: parent
                text: Constants.labelDnd
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontTiny
                font.bold: true
                color: service?.dndEnabled ? Colors.surface : Colors.muted
            }
        }
    }

    Pressable {
        width: CenterConfig.clearButtonSize
        height: CenterConfig.clearButtonSize
        onClicked: clearAllRequested()

        Rectangle {
            anchors.fill: parent
            radius: CenterConfig.buttonRadius
            color: Colors.surfaceContainer
            Text {
                anchors.centerIn: parent
                text: Constants.labelClear
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontMedium
                color: Colors.text
            }
        }
    }
}
