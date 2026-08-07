import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../theme"

// Единый слайдер. Заменяет дубликаты: features/Sliders/Slider и
// features/ControlPanel/CenterPanel/ControlSlider.
// - muted/mutedIcon: для громкости (иконка и fill гаснут при mute).
// - interactiveIcon: иконка кликабельна (toggle mute).
// - trackWidth: ширина трека; если 0 — трек растягивается (Layout.fillWidth).
RowLayout {
    id: root

    property real value: 0.0
    property real step: 0.05
    property string iconSource: ""
    property string mutedIcon: iconSource
    property bool muted: false
    property bool interactiveIcon: false
    property real trackWidth: UiConfig.sliderTrackDefaultWidth
    property real trackHeight: UiConfig.sliderTrackHeight
    property real iconBoxSize: UiConfig.sliderIconBoxSize
    property real iconSize: UiConfig.sliderIconSize
    property real textWidth: UiConfig.sliderTextWidth
    property real textSize: UiConfig.sliderTextSize

    readonly property real clampedValue: Math.max(0.0, Math.min(1.0, root.value))
    property real visualValue: clampedValue

    signal sliderMoved(real newValue)
    signal iconClicked

    implicitWidth: trackWidth + iconBoxSize + textWidth + (spacing * 2)
    spacing: 12

    Behavior on visualValue {
        enabled: !sliderMouse.pressed
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Item {
        id: iconBox
        Layout.preferredWidth: iconBoxSize
        Layout.preferredHeight: iconBoxSize
        Layout.alignment: Qt.AlignVCenter

        property string displayedSource: root.iconSource

        SequentialAnimation {
            id: iconSwitchAnimation
            NumberAnimation {
                target: iconEffect
                property: "opacity"
                to: 0.0
                duration: Motion.morph
                easing.type: Motion.easeStandard
            }
            ScriptAction {
                script: iconBox.displayedSource = root.muted && root.mutedIcon !== "" ? root.mutedIcon : root.iconSource
            }
            NumberAnimation {
                target: iconEffect
                property: "opacity"
                to: 1.0
                duration: Motion.morph
                easing.type: Motion.easeStandard
            }
        }

        Connections {
            target: root
            function onIconSourceChanged() {
                if (iconEffect.opacity > 0) {
                    iconSwitchAnimation.restart();
                } else {
                    iconBox.displayedSource = root.muted && root.mutedIcon !== "" ? root.mutedIcon : root.iconSource;
                }
            }
            function onMutedChanged() {
                if (iconEffect.opacity > 0) {
                    iconSwitchAnimation.restart();
                } else {
                    iconBox.displayedSource = root.muted && root.mutedIcon !== "" ? root.mutedIcon : root.iconSource;
                }
            }
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: iconSize
            height: iconSize
            source: iconBox.displayedSource
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            sourceSize: Qt.size(iconSize, iconSize)
            visible: false
        }

        MultiEffect {
            id: iconEffect
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: iconMouse.containsMouse ? ThemeColor.primary : ThemeColor.on_surface
            opacity: (root.muted ? 0.5 : 1.0)

            Behavior on colorizationColor {
                ColorAnimation {
                    duration: Motion.fast
                }
            }
        }

        MouseArea {
            id: iconMouse
            anchors.fill: parent
            hoverEnabled: root.interactiveIcon
            enabled: root.interactiveIcon
            cursorShape: root.interactiveIcon ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: root.iconClicked()
        }
    }

    Rectangle {
        id: track
        Layout.preferredWidth: root.trackWidth > 0 ? root.trackWidth : undefined
        Layout.fillWidth: root.trackWidth <= 0
        Layout.preferredHeight: trackHeight
        Layout.alignment: Qt.AlignVCenter
        radius: height / 2
        color: ThemeColor.surface_container_high
        border.color: sliderMouse.containsMouse ? ThemeColor.primary : "transparent"
        border.width: 1
        clip: true

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * (root.muted ? 0 : root.visualValue)
            radius: parent.radius
            color: root.muted ? "transparent" : ThemeColor.primary

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
                const nextValue = Math.max(0.0, Math.min(1.0, mouseX / width));
                root.sliderMoved(nextValue);
            }

            onPressed: mouse => updatePos(mouse.x)
            onPositionChanged: mouse => {
                if (pressed)
                    updatePos(mouse.x);
            }
            onWheel: wheel => {
                const delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                const nextValue = Math.max(0.0, Math.min(1.0, root.value + delta));
                root.sliderMoved(nextValue);
            }
        }
    }

    Text {
        Layout.preferredWidth: textWidth
        Layout.alignment: Qt.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: Math.round((root.muted ? 0 : root.clampedValue) * 100) + "%"
        color: ThemeColor.on_surface
        font {
            family: Theme.font
            pixelSize: textSize
        }
    }
}