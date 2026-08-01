import QtQuick
import QtQuick.Layouts
import "../../theme"

RowLayout {
    id: root

    property real value: 0.0
    property real step: 0.05
    property string iconSource: ""
    property real iconOpacity: 1.0
    property bool interactiveIcon: false
    property color fillColor: Theme.accent
    property real percentWidth: 40

    signal requestValueChange(real requestedValue)
    signal iconClicked
    signal interacted

    spacing: 10

    Rectangle {
        id: iconBtn
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        Layout.alignment: Qt.AlignVCenter
        radius: 10
        color: Theme.surface1
        border.color: (root.interactiveIcon && iconMouse.containsMouse) ? Theme.accentSoft : Theme.panelBorder
        border.width: 1

        Image {
            anchors.centerIn: parent
            width: 18
            height: 18
            source: root.iconSource
            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: root.iconOpacity
        }

        MouseArea {
            id: iconMouse
            anchors.fill: parent
            hoverEnabled: root.interactiveIcon
            enabled: root.interactiveIcon
            onClicked: {
                root.iconClicked();
                root.interacted();
            }
        }
    }

    Rectangle {
        id: track
        Layout.preferredWidth: 180
        Layout.preferredHeight: 10
        Layout.alignment: Qt.AlignVCenter
        radius: height / 2
        color: Theme.surface1
        border.color: sliderMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
        border.width: 1
        clip: true

        Rectangle {
            height: parent.height
            width: parent.width * Math.max(0.0, Math.min(1.0, root.value))
            radius: parent.radius
            color: root.fillColor

            Behavior on width {
                enabled: !sliderMouse.pressed
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
        }

        MouseArea {
            id: sliderMouse
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true

            function updatePos(mouseX) {
                let val = Math.max(0.0, Math.min(1.0, mouseX / width));
                root.requestValueChange(val);
                root.interacted();
            }

            onPressed: mouse => updatePos(mouse.x)
            onPositionChanged: mouse => {
                if (pressed)
                    updatePos(mouse.x);
            }
            onWheel: wheel => {
                let delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                let val = Math.max(0.0, Math.min(1.0, root.value + delta));
                root.requestValueChange(val);
                root.interacted();
            }
        }
    }

    Text {
        Layout.preferredWidth: root.percentWidth
        Layout.alignment: Qt.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.value * 100) + "%"
        color: Theme.text
        font.pixelSize: 14
    }
}
