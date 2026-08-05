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

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    width: ListView.view ? ListView.view.width : SelectorConfig.width
    height: isInputting ? SelectorConfig.cardInputHeight : SelectorConfig.cardBaseHeight
    implicitHeight: height
    radius: SelectorConfig.cardRadius

    color: isConnected ? ThemeColor.primary : ThemeColor.surface_container_low
    border.color: (hovered && !isConnected) ? ThemeColor.primary : "transparent"
    border.width: SelectorConfig.cardBorderWidth
    clip: true

    scale: pressed ? SelectorConfig.cardPressedScale : (hovered ? SelectorConfig.cardHoverScale : 0.95)

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
        width: parent.width - (SelectorConfig.cardContentMargin * 2)
        spacing: SelectorConfig.cardContentSpacing

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.isConnecting ? "Connecting" : root.name
            font.family: Theme.font
            font.pixelSize: SelectorConfig.cardTextSize
            color: root.isConnected ? ThemeColor.on_primary : ThemeColor.on_surface
            opacity: root.isConnecting ? pulseAnim.opacityValue : 1.0

            NumberAnimation on opacity {
                id: pulseAnim
                property real opacityValue: 1.0
                from: 1.0
                to: SelectorConfig.pulseMinOpacity
                duration: SelectorConfig.pulseDuration
                loops: Animation.Infinite
                running: root.isConnecting
                easing.type: Easing.InOutSine
            }
        }

        Rectangle {
            id: inputContainer
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: SelectorConfig.inputContainerHeight
            radius: SelectorConfig.inputRadius
            color: ThemeColor.surface_container_highest
            visible: root.isInputting
            opacity: root.isInputting ? 1.0 : 0.0
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
                anchors.margins: SelectorConfig.inputPadding
                verticalAlignment: TextInput.AlignVCenter
                color: ThemeColor.on_surface
                font.pixelSize: SelectorConfig.cardTextSize
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

    HoverHandler {
        id: hoverHandler
        cursorShape: (root.isConnected || root.isConnecting) ? Qt.ArrowCursor : Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: {
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
