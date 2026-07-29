import QtQuick

Item {
    id: root

    property string glyph: "⏻"
    property string label: "Action"
    property color accent: "#FFFFFF"

    signal activated
    signal focusCleared

    width: 112
    height: 124
    scale: activeFocus ? 1.08 : 1.0
    transformOrigin: Item.Center

    activeFocusOnTab: true

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
        color: root.activeFocus ? "#33FFFFFF" : "#18FFFFFF"
        border.width: root.activeFocus ? 2 : 0
        border.color: root.accent
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: 140
            }
        }

        Behavior on border.color {
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
                color: root.activeFocus ? root.accent : "#FFFFFF"
                font.pixelSize: 32
                font.bold: true
                renderType: Text.NativeRendering

                Behavior on color {
                    ColorAnimation {
                        duration: 140
                    }
                }
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

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.activated();
            event.accepted = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            root.forceActiveFocus();
        }
        onExited: {
            if (root.activeFocus) {
                root.focusCleared();
            }
        }
        onClicked: {
            root.activated();
        }
    }
}
