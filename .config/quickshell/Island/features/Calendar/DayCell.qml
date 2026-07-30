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
    readonly property bool isHovered: hovered && inMonth

    width: 30
    height: 30
    transformOrigin: Item.Center
    scale: isHovered ? 1.1 : 1.0
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
        color: selected ? Theme.accent : (isHovered ? Theme.hover : "transparent")
        border.width: (selected || isToday || isHovered) ? 1 : 0
        border.color: selected || isToday ? Theme.accent : Theme.separator
    }

    Text {
        anchors.centerIn: parent
        text: inMonth ? dayNumber : ""
        font.family: Theme.font
        font.pixelSize: 12
        font.weight: selected ? Font.DemiBold : Font.Medium
        color: selected ? Theme.accentText : (isToday ? Theme.text : Theme.textMuted)
        antialiasing: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: inMonth
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
