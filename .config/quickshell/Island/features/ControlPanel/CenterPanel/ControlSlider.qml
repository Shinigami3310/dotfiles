import QtQuick
import QtQuick.Effects
import "../../../theme"

Item {
    id: root

    // Локальная константа
    readonly property real controlSliderHeight: 24
    readonly property int iconSize: 24
    property string icon: ""
    property string mutedIcon: icon
    property real value: 0.0
    property bool muted: false
    property real step: 0.05

    // Новое свойство для отключения интерактивности иконки
    property bool interactiveIcon: false

    signal sliderMoved(real newValue)
    signal iconClicked

    implicitWidth: 300
    implicitHeight: 36

    Row {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            id: iconBtn

            width: 36
            height: 36
            radius: 10

            // Цвета как в обновленном ControlButton
            color: "transparent"

            // Анимация нажатия и наведения (только если интерактивно)
            scale: (iconTap.pressed && root.interactiveIcon) ? 0.95 : ((iconHover.hovered && root.interactiveIcon) ? 1.05 : 1.0)

            Behavior on scale {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack
                }
            }

            // Плавная смена иконки
            property string currentIconString: root.muted ? root.mutedIcon : root.icon
            property string targetIcon: currentIconString !== "" ? Qt.resolvedUrl("../../../assets/icons/" + currentIconString) : ""
            property string displayedSource: targetIcon
            property real transitionOpacity: 1.0

            SequentialAnimation {
                id: iconSwitchAnimation
                NumberAnimation {
                    target: iconBtn
                    property: "transitionOpacity"
                    to: 0.0
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
                ScriptAction {
                    script: iconBtn.displayedSource = iconBtn.targetIcon
                }
                NumberAnimation {
                    target: iconBtn
                    property: "transitionOpacity"
                    to: 1.0
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }

            Connections {
                target: iconBtn
                function onTargetIconChanged() {
                    if (iconBtn.transitionOpacity > 0) {
                        iconSwitchAnimation.restart();
                    } else {
                        iconBtn.displayedSource = iconBtn.targetIcon;
                    }
                }
            }

            Image {
                id: iconImage
                anchors.centerIn: parent
                width: iconSize
                height: iconSize
                source: iconBtn.displayedSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                visible: false
                sourceSize: Qt.size(iconSize * 2, iconSize * 2) // Четкость без пикселей
            }

            MultiEffect {
                anchors.fill: iconImage
                source: iconImage
                colorization: 1.0
                colorizationColor: (iconHover.hovered && root.interactiveIcon) ? ThemeColor.primary : ThemeColor.on_surface
                opacity: (root.muted ? 0.5 : 1.0) * iconBtn.transitionOpacity

                Behavior on colorizationColor {
                    ColorAnimation {
                        duration: Motion.fast
                    }
                }
            }

            HoverHandler {
                id: iconHover
                enabled: root.interactiveIcon
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: iconTap
                enabled: root.interactiveIcon
                onTapped: root.iconClicked()
            }
        }

        Rectangle {
            id: track
            anchors.verticalCenter: parent.verticalCenter
            height: controlSliderHeight
            // Расчет ширины трека с учетом иконки, текста процента и двух отступов spacing
            width: parent.width - iconBtn.width - valueText.width - (parent.spacing * 2)
            radius: 10

            // Цвета трека приведены к новой схеме
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
                id: fillRect
                height: parent.height
                width: parent.width * (root.muted ? 0 : root.value)
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

            // MouseArea отлично подходит для слайдера, так как легко перехватывает drag и колесо
            MouseArea {
                id: sliderMouse
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true

                function updatePos(mouseX) {
                    let val = Math.max(0.0, Math.min(1.0, mouseX / width));
                    root.sliderMoved(val);
                }

                onPressed: mouse => updatePos(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updatePos(mouse.x);
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
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            horizontalAlignment: Text.AlignRight
            text: Math.round((root.muted ? 0 : root.value) * 100) + "%"
            font.family: Theme.font
            font.pixelSize: 11
            color: ThemeColor.on_surface
        }
    }
}
