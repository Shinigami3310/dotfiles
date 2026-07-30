import QtQuick
import "../../Singletons/"

Item {
    id: root

    property string icon: ""        // Имя файла иконки (например, "volume.svg")
    property string mutedIcon: icon // Имя файла для выключенного состояния
    property real value: 0.0        // Значение от 0.0 до 1.0
    property bool muted: false
    property real step: 0.05        // Шаг изменения при прокрутке колесом (5%)

    signal sliderMoved(real newValue)
    signal iconClicked

    implicitWidth: 300
    implicitHeight: 36

    Row {
        anchors.fill: parent
        spacing: 12

        // Кнопка иконки
        Rectangle {
            id: iconBtn

            width: 36
            height: 36
            radius: 10
            color: Theme.surface1
            border.color: iconMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
            border.width: 1

            Image {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: Qt.resolvedUrl("../../assets/icons/" + (root.muted ? root.mutedIcon : root.icon))
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: root.muted ? 0.4 : 1.0
            }

            MouseArea {
                id: iconMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.iconClicked()
            }
        }

        // Полоса слайдера
        Rectangle {
            id: track

            height: 36
            width: parent.width - iconBtn.width - parent.spacing
            radius: 10
            color: Theme.surface1
            border.color: sliderMouse.containsMouse ? Theme.accentSoft : Theme.panelBorder
            border.width: 1
            clip: true

            Rectangle {
                id: fillRect

                height: parent.height
                width: parent.width * (root.muted ? 0 : root.value)
                radius: 10
                color: root.muted ? Theme.surface2 : Theme.accent

                Behavior on width {
                    enabled: !sliderMouse.pressed
                    NumberAnimation {
                        duration: Motion.fast
                        easing.type: Motion.easeStandard
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round((root.muted ? 0 : root.value) * 100) + "%"
                font.family: Theme.font
                font.pixelSize: 11
                color: root.muted ? Theme.textDim : Theme.textMuted
            }

            MouseArea {
                id: sliderMouse

                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true

                function updatePos(mouseX) {
                    let val = Math.max(0.0, Math.min(1.0, mouseX / width));
                    root.sliderMoved(val);
                }

                // Клик и перетаскивание
                onPressed: mouse => updatePos(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updatePos(mouse.x);
                }

                // Вращение колеса мыши при наведении
                onWheel: wheel => {
                    let delta = wheel.angleDelta.y > 0 ? root.step : -root.step;
                    let newVal = Math.max(0.0, Math.min(1.0, root.value + delta));
                    root.sliderMoved(newVal);
                }
            }
        }
    }
}
