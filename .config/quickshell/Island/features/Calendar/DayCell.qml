import QtQuick
import "../../theme"

Item {
    id: root

    property int dayNumber: 0
    property bool inMonth: false
    property bool selected: false
    property bool isToday: false
    property bool isPast: false

    signal clicked

    readonly property bool hovered: mouseArea.containsMouse

    width: 30
    height: 30
    transformOrigin: Item.Center

    scale: hovered ? 1.1 : 1.0
    opacity: isPast ? 0.5 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: root.selected ? Theme.accent : (root.hovered ? Theme.hover : "transparent")
        border.width: (root.selected || root.isToday || root.hovered) ? 1 : 0
        border.color: (root.selected || root.isToday) ? Theme.accent : Theme.separator
    }

    Text {
        anchors.centerIn: parent
        text: root.inMonth ? root.dayNumber : ""
        font {
            family: Theme.font
            pixelSize: 12
            weight: root.selected ? Font.DemiBold : Font.Medium
        }
        color: root.selected ? Theme.accentText : (root.isToday ? Theme.text : Theme.textMuted)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.inMonth
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
