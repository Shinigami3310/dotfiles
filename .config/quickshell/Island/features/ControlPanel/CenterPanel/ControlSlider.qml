import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../../theme"
import "../"

Item {
    id: root

    property string icon: ""
    property string mutedIcon: icon
    property real value: 0.0
    property bool muted: false
    property real step: 0.05
    property bool interactiveIcon: false

    signal sliderMoved(real newValue)
    signal iconClicked

    implicitWidth: ControlPanelConfig.panelWidth
    implicitHeight: ControlPanelConfig.sliderHeight

    RowLayout {
        anchors.fill: parent
        spacing: ControlPanelConfig.rowSpacing

        Rectangle {
            id: iconBtn
            Layout.preferredWidth: ControlPanelConfig.sliderIconContainerSize
            Layout.preferredHeight: ControlPanelConfig.sliderIconContainerSize
            radius: ControlPanelConfig.sliderRadius
            color: "transparent"

            scale: (iconMouseArea.pressed && root.interactiveIcon) ? ControlPanelConfig.buttonPressedScale : ((iconMouseArea.containsMouse && root.interactiveIcon) ? ControlPanelConfig.buttonHoverScale : 1.0)

            Behavior on scale {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack
                }
            }

            property string targetIcon: (root.muted && root.mutedIcon !== "") ? root.mutedIcon : root.icon
            property string displayedSource: targetIcon !== "" ? Qt.resolvedUrl("../../../assets/icons/" + targetIcon) : ""
            property real transitionOpacity: 1.0

            SequentialAnimation {
                id: iconSwitchAnimation
                NumberAnimation {
                    target: iconBtn
                    property: "transitionOpacity"
                    to: 0.0
                    duration: Motion.fast
                }
                ScriptAction {
                    script: iconBtn.displayedSource = Qt.resolvedUrl("../../../assets/icons/" + iconBtn.targetIcon)
                }
                NumberAnimation {
                    target: iconBtn
                    property: "transitionOpacity"
                    to: 1.0
                    duration: Motion.fast
                }
            }

            onTargetIconChanged: {
                if (transitionOpacity > 0) {
                    iconSwitchAnimation.restart();
                } else {
                    displayedSource = Qt.resolvedUrl("../../../assets/icons/" + targetIcon);
                }
            }

            Image {
                id: iconImage
                anchors.centerIn: parent
                width: ControlPanelConfig.sliderIconSize
                height: ControlPanelConfig.sliderIconSize
                source: iconBtn.displayedSource
                sourceSize: Qt.size(width * 2, height * 2)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                visible: false
            }

            MultiEffect {
                anchors.fill: iconImage
                source: iconImage
                colorization: 1.0
                colorizationColor: (iconMouseArea.containsMouse && root.interactiveIcon) ? ThemeColor.primary : ThemeColor.on_surface
                opacity: (root.muted ? 0.5 : 1.0) * iconBtn.transitionOpacity

                Behavior on colorizationColor {
                    ColorAnimation {
                        duration: Motion.fast
                    }
                }
            }

            MouseArea {
                id: iconMouseArea
                anchors.fill: parent
                enabled: root.interactiveIcon
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.iconClicked()
            }
        }

        Rectangle {
            id: track
            height: ControlPanelConfig.sliderTrackHeight
            Layout.fillWidth: true
            radius: ControlPanelConfig.sliderRadius
            color: ThemeColor.surface_container_high
            border.color: trackMouseArea.containsMouse ? ThemeColor.primary : "transparent"
            border.width: 1
            clip: true

            Behavior on border.color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }

            Rectangle {
                id: fillRect
                height: parent.height
                width: parent.width * (root.muted ? 0 : root.value)
                radius: parent.radius
                color: root.muted ? "transparent" : ThemeColor.primary

                Behavior on width {
                    enabled: !trackMouseArea.pressed
                    NumberAnimation {
                        duration: Motion.fast
                        easing.type: Motion.easeStandard
                    }
                }
            }

            function updateValueFromX(xPos) {
                let val = Math.max(0.0, Math.min(1.0, xPos / track.width));
                root.sliderMoved(val);
            }

            MouseArea {
                id: trackMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onPressed: mouse => track.updateValueFromX(mouse.x)

                onPositionChanged: mouse => {
                    if (pressed)
                        track.updateValueFromX(mouse.x);
                }

                onWheel: wheel => {
                    let delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                    let newVal = Math.max(0.0, Math.min(1.0, root.value + delta));
                    root.sliderMoved(newVal);
                }
            }
        }

        Text {
            id: valueText
            width: ControlPanelConfig.sliderTextWidth
            horizontalAlignment: Text.AlignRight
            text: Math.round((root.muted ? 0 : root.value) * 100) + "%"
            font.family: Theme.font
            font.pixelSize: ControlPanelConfig.sliderTextSize
            color: ThemeColor.on_surface
        }
    }
}
