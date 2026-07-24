import QtQuick
import "../Singletons"

Item {
    id: root

    property date dateTime: new Date()

    property real paddingX: 10
    property real paddingY: 5
    property int timePixelSize: 18
    property int datePixelSize: 10

    implicitWidth: column.implicitWidth + paddingX * 2
    implicitHeight: column.implicitHeight + paddingY * 2
    width: implicitWidth
    height: implicitHeight

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: Qt.formatDateTime(root.dateTime, "hh:mm")
            font.family: Theme.font
            font.pixelSize: root.timePixelSize
            font.weight: Font.Medium
            color: Theme.text
            antialiasing: true
        }

        Text {
            text: Qt.formatDateTime(root.dateTime, "ddd dd MMM").toUpperCase()
            font.family: Theme.font
            font.pixelSize: root.datePixelSize
            font.weight: Font.Medium
            color: Theme.textMuted
            antialiasing: true
        }
    }
}
