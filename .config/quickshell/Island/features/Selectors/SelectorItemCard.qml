import QtQuick
import "../../theme"

Rectangle {
    id: root

    // Локальные константы
    readonly property real cardBaseHeight: 48
    readonly property real cardInputHeight: 88
    readonly property real cardRadius: 12
    readonly property real scaleHover: 1.02
    readonly property real scalePressed: 0.95
    readonly property real fallbackWidth: 320

    property string name: "Unknown"
    property string security: ""
    property bool isConnected: false
    property bool isConnecting: false
    property bool isInputting: false

    signal connectRequested(string password)

    width: ListView.view ? ListView.view.width : fallbackWidth
    height: isInputting ? cardInputHeight : cardBaseHeight
    implicitHeight: height
    radius: cardRadius

    color: isConnected ? ThemeColor.primary : ThemeColor.surface_container_low
    border.color: (mouseArea.containsMouse && !isConnected) ? ThemeColor.primary : "transparent"
    border.width: 1
    clip: true

    scale: mouseArea.pressed ? 0.95 : (mouseArea.containsMouse ? 1 : 0.95)

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

    Behavior on border.color {
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
            color: root.isConnected ? ThemeColor.on_primary : ThemeColor.on_surface
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
            color: ThemeColor.surface_container_highest
            visible: root.isInputting
            opacity: root.isInputting ? 1 : 0
            border.color: pwdInput.activeFocus ? ThemeColor.primary : "transparent"
            border.width: 1

            Behavior on opacity {
                NumberAnimation {
                    duration: Motion.fast
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }

            TextInput {
                id: pwdInput
                anchors.fill: parent
                anchors.margins: 8
                verticalAlignment: TextInput.AlignVCenter
                color: ThemeColor.on_surface
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
