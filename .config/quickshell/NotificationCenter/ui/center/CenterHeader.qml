import QtQuick
import QtQuick.Layouts
import "../../config"

RowLayout {
    id: root
    property var service

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

        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: (root.service && root.service.filterLow) ? Colors.borderLow : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderLow
            MouseArea {
                anchors.fill: parent
                onClicked: if (root.service)
                    root.service.filterLow = !root.service.filterLow
            }
        }
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: (root.service && root.service.filterNormal) ? Colors.borderNormal : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderNormal
            MouseArea {
                anchors.fill: parent
                onClicked: if (root.service)
                    root.service.filterNormal = !root.service.filterNormal
            }
        }
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: (root.service && root.service.filterCritical) ? Colors.borderCritical : Colors.surfaceContainer
            border.width: 1
            border.color: Colors.borderCritical
            MouseArea {
                anchors.fill: parent
                onClicked: if (root.service)
                    root.service.filterCritical = !root.service.filterCritical
            }
        }
    }

    // --- Кнопка DND Mode ---
    Rectangle {
        width: 50
        height: 24
        radius: 12
        color: (root.service && root.service.dndEnabled) ? Colors.primary : Colors.surfaceContainer

        Text {
            anchors.centerIn: parent
            text: "DND"
            font.pixelSize: 10
            font.bold: true
            color: (root.service && root.service.dndEnabled) ? Colors.surface : Colors.muted
        }

        MouseArea {
            anchors.fill: parent
            onClicked: if (root.service)
                root.service.toggleDnd()
        }
    }

    // --- Кнопка Очистки Истории ---
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
            onClicked: root.clearAllRequested()
        }
    }
}
