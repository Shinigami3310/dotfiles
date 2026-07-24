import QtQuick
import "../Singletons"

Item {
    id: root

    property real size: 30
    property real radius: 2

    property bool active: false
    property bool enabled: true
    property string glyph: ""

    property color idleBackground: "transparent"
    property color hoverBackground: Theme.hover
    property color pressedBackground: Theme.pressed
    property color activeBackground: Theme.accentSoft

    property color idleBorder: "transparent"
    property color hoverBorder: Theme.separator
    property color activeBorder: Theme.accent

    property color idleForeground: Theme.textMuted
    property color hoverForeground: Theme.text
    property color activeForeground: Theme.accent

    property int glyphPixelSize: Math.round(size * 0.45)

    signal clicked
    signal secondaryClicked

    implicitWidth: size
    implicitHeight: size
    width: implicitWidth
    height: implicitHeight

    readonly property bool hovered: area.containsMouse

    opacity: enabled ? 1.0 : 0.45
    scale: area.containsPress ? 0.95 : 1.0
    transformOrigin: Item.Center

    function bgColor() {
        if (!enabled)
            return "transparent";
        if (area.containsPress)
            return pressedBackground;
        if (active)
            return activeBackground;
        if (hovered)
            return hoverBackground;
        return idleBackground;
    }

    function borderColor() {
        if (active)
            return activeBorder;
        if (hovered)
            return hoverBorder;
        return idleBorder;
    }

    function fgColor() {
        if (active)
            return activeForeground;
        if (hovered)
            return hoverForeground;
        return idleForeground;
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Motion.click
            easing.type: Motion.easeOut
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.bgColor()
        border.width: root.hovered || root.active ? 1 : 0
        border.color: root.borderColor()

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
        Behavior on border.width {
            NumberAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.glyph.length > 0
        text: root.glyph
        color: root.fgColor()
        font.family: Theme.font
        font.pixelSize: root.glyphPixelSize
        font.weight: Font.DemiBold
        antialiasing: true

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton)
                root.secondaryClicked();
            else
                root.clicked();
        }
    }
}
