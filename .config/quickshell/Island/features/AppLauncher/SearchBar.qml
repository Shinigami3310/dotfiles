import QtQuick
import "../../theme"

FocusScope {
    id: root

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
        color: ThemeColor.surface
        border {
            color: input.activeFocus ? ThemeColor.primary : "transparent"
            width: 2
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }

        Row {
            anchors {
                fill: parent
                leftMargin: 16
                rightMargin: 16
            }
            spacing: 12

            Text {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                text: "🔍"
                font.pixelSize: 16
                color: input.activeFocus ? ThemeColor.primary : ThemeColor.on_surface
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - searchIcon.width - parent.spacing
                focus: true
                clip: true

                font {
                    family: Theme.font
                    pixelSize: 15
                }
                color: Theme.text
                selectionColor: Theme.accent
                selectedTextColor: Theme.accentText

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
