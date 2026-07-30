import QtQuick
import QtQuick.Layouts
import "../../Singletons"
import "../../services/Demons"

Item {
    id: root

    property bool active: false
    property real step: 0.05

    signal backRequested

    readonly property real trackWidth: 180
    readonly property real trackHeight: 10
    readonly property real iconSize: 32
    readonly property real percentWidth: 40
    readonly property real paddingX: 16
    readonly property real paddingY: 12

    implicitWidth: row.implicitWidth + paddingX * 2
    implicitHeight: row.implicitHeight + paddingY * 2

    function bumpIdle() {
        if (root.active)
            idleTimer.restart();
    }

    Timer {
        id: idleTimer
        interval: 5000
        repeat: false
        running: root.active
        onTriggered: root.backRequested()
    }

    onActiveChanged: if (active)
        bumpIdle()

    Connections {
        target: BrightnessService
        function onLevelChanged() {
            root.bumpIdle();
        }
    }

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 10

        Rectangle {
            id: iconBox

            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            Layout.alignment: Qt.AlignVCenter
            radius: 10
            color: Theme.surface1
            border.color: Theme.panelBorder
            border.width: 1

            Image {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: Qt.resolvedUrl("../../assets/icons/Brightness.png")
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        Rectangle {
            id: track

            Layout.preferredWidth: root.trackWidth
            Layout.preferredHeight: root.trackHeight
            Layout.alignment: Qt.AlignVCenter
            radius: root.trackHeight / 2
            color: Theme.surface1
            border.color: sliderMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
            border.width: 1
            clip: true

            Rectangle {
                height: parent.height
                width: parent.width * BrightnessService.level
                radius: root.trackHeight / 2
                color: Theme.accent

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
                    BrightnessService.setLevel(val);
                    root.bumpIdle();
                }

                onPressed: mouse => updatePos(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updatePos(mouse.x);
                }
                onWheel: wheel => {
                    let delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                    let newVal = Math.max(0.0, Math.min(1.0, BrightnessService.level + delta));
                    BrightnessService.setLevel(newVal);
                    root.bumpIdle();
                }
            }
        }

        Text {
            Layout.preferredWidth: root.percentWidth
            Layout.alignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: Math.round(BrightnessService.level * 100) + "%"
            font.family: Theme.font
            font.pixelSize: 11
            color: Theme.textMuted
        }
    }
}
