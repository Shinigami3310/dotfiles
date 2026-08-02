import QtQuick
import "../../theme"

FocusScope {
    id: root

    implicitHeight: Configs.appSearchHeight
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
        radius: Configs.appSearchRadius
        color: Theme.surface2
        border {
            color: input.activeFocus ? Theme.accent : "transparent"
            width: 1
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
                leftMargin: Configs.appSearchIconMargin
                rightMargin: Configs.appSearchIconMargin
            }
            spacing: Configs.appSearchSpacing

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "🔍"
                font.pixelSize: Configs.appSearchIconSize
                color: input.activeFocus ? Theme.accent : Theme.textMuted
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Configs.appSearchIconSize - Configs.appSearchSpacing
                focus: true
                clip: true

                font {
                    family: Theme.font
                    pixelSize: Configs.appSearchTextSize
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
