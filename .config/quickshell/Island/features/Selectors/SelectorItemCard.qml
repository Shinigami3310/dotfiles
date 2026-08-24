import QtQuick
import "../../shared/theme"

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
    border.color: (hovered && !isConnected) ? ThemeColor.primary : ThemeColor.transparent
    border.width: SelectorConfig.cardBorderWidth
    clip: true

    scale: pressed ? SelectorConfig.scalePressed : (hovered ? SelectorConfig.scaleHover : 0.95)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Motion.curveScaleRelease
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Motion.curveResize
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Motion.durationFast
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: Motion.durationFast
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

        PasswordField {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            active: root.isInputting
            onSubmitted: password => {
                root.isInputting = false;
                root.connectRequested(password);
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
            } else if (!root.isInputting) {
                root.connectRequested("");
            }
        }
    }
}
