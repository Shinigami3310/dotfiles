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

    readonly property real clampedValue: Math.max(0.0, Math.min(1.0, root.value))
    property real visualValue: clampedValue

    signal requestValueChange(real requestedValue)
    signal iconClicked
    signal interacted

    implicitWidth: Configs.sliderTrackDefaultWidth + Configs.sliderIconBoxSize + Configs.sliderTextWidth + (spacing * 2)
    spacing: 12

    Behavior on visualValue {
        enabled: !sliderMouse.pressed
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Rectangle {
        id: iconBtn
        Layout.preferredWidth: Configs.sliderIconBoxSize
        Layout.preferredHeight: Configs.sliderIconBoxSize
        Layout.alignment: Qt.AlignVCenter
        radius: 10
        color: Theme.surface1

        border {
            color: (root.interactiveIcon && iconMouse.containsMouse) ? Theme.accentSoft : Theme.panelBorder
            width: 1
        }

        Image {
            anchors.centerIn: parent
            width: Configs.sliderIconSize
            height: Configs.sliderIconSize
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
            cursorShape: root.interactiveIcon ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: {
                root.iconClicked();
                root.interacted();
            }
        }
    }

    Rectangle {
        id: track
        width: Configs.sliderTrackDefaultWidth
        Layout.preferredHeight: Configs.sliderTrackHeight
        Layout.alignment: Qt.AlignVCenter
        radius: height / 2
        color: Theme.surface1
        clip: true

        border {
            color: sliderMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
            width: 1
        }

        Rectangle {
            height: parent.height
            width: parent.width * root.visualValue
            radius: parent.radius
            color: root.fillColor
        }

        MouseArea {
            id: sliderMouse
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true

            function updatePos(mouseX) {
                const nextValue = Math.max(0.0, Math.min(1.0, mouseX / width));
                root.requestValueChange(nextValue);
                root.interacted();
            }

            onPressed: mouse => updatePos(mouse.x)
            onPositionChanged: mouse => {
                if (pressed)
                    updatePos(mouse.x);
            }
            onWheel: wheel => {
                const delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                const nextValue = Math.max(0.0, Math.min(1.0, root.value + delta));
                root.requestValueChange(nextValue);
                root.interacted();
            }
        }
    }

    Text {
        Layout.preferredWidth: Configs.sliderTextWidth
        Layout.alignment: Qt.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.clampedValue * 100) + "%"
        color: Theme.text
        font {
            family: Theme.font
            pixelSize: 13
        }
    }
}
