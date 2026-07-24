import QtQuick
import "../Singletons"

Item {
    id: root

    property date dateTime: new Date()

    property real paddingX: 30
    property real paddingY: 5
    property int timePixelSize: 18

    implicitWidth: clockText.implicitWidth + paddingX * 2
    implicitHeight: clockText.implicitHeight + paddingY * 2
    width: implicitWidth
    height: implicitHeight

    Text {
        id: clockText
        anchors.centerIn: parent

        text: Qt.formatDateTime(root.dateTime, "hh:mm")
        font.family: Theme.font
        font.pixelSize: root.timePixelSize
        font.weight: Font.Medium
        color: Theme.text
        antialiasing: true
    }
}
