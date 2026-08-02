import QtQuick
import "../../theme"

Rectangle {
    id: root

    property string name: "Unknown"
    property string security: ""
    property bool isConnected: false
    property bool isConnecting: false
    property bool isInputting: false

    signal connectRequested(string password)

    width: ListView.view ? ListView.view.width : Configs.selectorWidth
    height: isInputting ? Configs.cardInputHeight : Configs.cardBaseHeight
    implicitHeight: height
    radius: Configs.cardRadius

    color: isConnected ? Theme.accent : Theme.surface1
    border.color: (mouseArea.containsMouse && !isConnected) ? Theme.accentSoft : "transparent"
    border.width: 1
    clip: true

    scale: mouseArea.pressed ? Configs.clickScale : (mouseArea.containsMouse ? Configs.hoverScale : 0.95)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutBack
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutQuart
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
        }
    }

    Column {
        anchors.centerIn: parent
        width: parent.width - 24
        spacing: 8

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.isConnecting ? "Connecting" : root.name
            font.family: Theme.font
            font.pixelSize: 13
            color: root.isConnected ? Theme.accentText : Theme.text
            opacity: root.isConnecting ? pulseAnim.opacityValue : 1.0

            NumberAnimation on opacity {
                id: pulseAnim
                property real opacityValue: 1.0
                from: 1.0
                to: 0.4
                duration: 600
                loops: Animation.Infinite
                running: root.isConnecting
                easing.type: Easing.InOutSine
            }
        }

        Rectangle {
            id: inputContainer
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 28
            radius: 6
            color: Theme.surface2
            visible: root.isInputting
            opacity: root.isInputting ? 1 : 0
            border.color: pwdInput.activeFocus ? Theme.accent : "transparent"

            Behavior on opacity {
                NumberAnimation {
                    duration: Motion.fast
                }
            }

            TextInput {
                id: pwdInput
                anchors.fill: parent
                anchors.margins: 8
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.text
                font.pixelSize: 13
                echoMode: TextInput.Password
                passwordCharacter: "•"

                onActiveFocusChanged: {
                    if (!activeFocus && root.isInputting && text === "") {
                        root.isInputting = false;
                    }
                }

                onAccepted: {
                    if (text.trim() !== "") {
                        root.isInputting = false;
                        root.connectRequested(text);
                        text = "";
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: (root.isConnected || root.isConnecting) ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: {
            if (root.isConnected || root.isConnecting)
                return;

            const requiresPassword = root.security !== "" && root.security !== "--";

            if (requiresPassword && !root.isInputting) {
                root.isInputting = true;
                pwdInput.forceActiveFocus();
            } else if (!root.isInputting) {
                root.connectRequested("");
            }
        }
    }
}
