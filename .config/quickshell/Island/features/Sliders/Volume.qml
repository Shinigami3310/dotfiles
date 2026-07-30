import QtQuick
import QtQuick.Layouts
import "../../Singletons"
import "../../services/integrations"

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
        target: AudioService
        function onVolumeChanged() {
            root.bumpIdle();
        }
        function onMutedChanged() {
            root.bumpIdle();
        }
    }

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 10

        Rectangle {
            id: iconBtn

            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            Layout.alignment: Qt.AlignVCenter
            radius: 10
            color: Theme.surface1
            border.color: iconMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
            border.width: 1

            Image {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: Qt.resolvedUrl("../../assets/icons/" + (AudioService.muted ? "VolumeMute.png" : "Volume.png"))
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: AudioService.muted ? 0.4 : 1.0
            }

            MouseArea {
                id: iconMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    AudioService.toggleMute();
                    root.bumpIdle();
                }
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
                width: parent.width * (AudioService.muted ? 0 : AudioService.volume)
                radius: root.trackHeight / 2
                color: AudioService.muted ? Theme.surface2 : Theme.accent

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
                    AudioService.setVolume(val);
                    root.bumpIdle();
                }

                onPressed: mouse => updatePos(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updatePos(mouse.x);
                }
                onWheel: wheel => {
                    let delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                    let newVal = Math.max(0.0, Math.min(1.0, AudioService.volume + delta));
                    AudioService.setVolume(newVal);
                    root.bumpIdle();
                }
            }
        }

        Text {
            Layout.preferredWidth: root.percentWidth
            Layout.alignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: Math.round((AudioService.muted ? 0 : AudioService.volume) * 100) + "%"
            font.family: Theme.font
            font.pixelSize: 11
            color: AudioService.muted ? Theme.textDim : Theme.textMuted
        }
    }
}
