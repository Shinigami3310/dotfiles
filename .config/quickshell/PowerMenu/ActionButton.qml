import QtQuick

Item {
    id: root

    property string glyph: "⏻"
    property string label: "Action"
    property color accent: "#FFFFFF"
    property bool hovered: false

    signal activated

    width: 112
    height: 124
    scale: hovered ? 1.08 : 1.0
    transformOrigin: Item.Center

    Behavior on scale {
        NumberAnimation {
            duration: 140
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: body
        anchors.centerIn: parent
        width: 96
        height: 96
        radius: 26
        color: root.hovered ? "#26FFFFFF" : "#18FFFFFF"
        border.width: 0
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: 140
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 6

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.glyph
                color: "#FFFFFF"
                font.pixelSize: 32
                font.bold: true
                renderType: Text.NativeRendering
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                color: "#E6FFFFFF"
                font.pixelSize: 13
                font.weight: Font.Medium
                renderType: Text.NativeRendering
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.activated()
    }
}
