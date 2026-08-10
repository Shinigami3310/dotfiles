import QtQuick

Item {
    id: root

    signal clicked
    readonly property bool hovered: pressArea.containsMouse
    readonly property bool pressed: pressArea.pressed

    scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)
    Behavior on scale {
        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }

    MouseArea {
        id: pressArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}