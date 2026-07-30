import QtQuick
import "../../Singletons/"

FocusScope {
    id: root

    implicitWidth: 360
    implicitHeight: 48
    focus: true

    property alias text: input.text

    signal upPressed
    signal downPressed
    signal enterPressed
    signal escapePressed

    function forceFocus() {
        input.forceActiveFocus();
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Theme.surface2
        border.color: input.activeFocus ? Theme.accent : "transparent"
        border.width: 1

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "🔍"
                font.pixelSize: 16
                color: input.activeFocus ? Theme.accent : Theme.textMuted
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 28
                focus: true

                font.family: Theme.font
                font.pixelSize: 15
                color: Theme.text
                selectionColor: Theme.accent
                selectedTextColor: Theme.accentText
                clip: true

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Enter app name"
                    font.family: Theme.font
                    font.pixelSize: 15
                    color: Theme.textMuted
                    visible: input.text === "" && !input.activeFocus
                }

                Keys.onUpPressed: root.upPressed()
                Keys.onDownPressed: root.downPressed()
                Keys.onReturnPressed: root.enterPressed()
                Keys.onEscapePressed: {
                    if (input.text !== "")
                        input.text = "";
                    else
                        root.escapePressed();
                }
            }
        }
    }
}
