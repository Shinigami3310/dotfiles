import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme"

RowLayout {
    id: root

    readonly property int iconBoxSize: 32
    readonly property int iconSize: 24
    readonly property int trackHeight: 10
    readonly property int trackDefaultWidth: 200
    readonly property int textWidth: 32

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

    implicitWidth: trackDefaultWidth + iconBoxSize + textWidth + (spacing * 2)
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

        // Локальное свойство для промежуточного хранения пути
        property string displayedSource: root.iconSource

        // Анимация смены иконки
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
                script: iconBox.displayedSource = root.iconSource
            }
            NumberAnimation {
                target: iconEffect
                property: "opacity"
                to: 1.0
                duration: Motion.morph
                easing.type: Motion.easeStandard
            }
        }

        // Отслеживаем изменение свойства iconSource извне
        Connections {
            target: root
            function onIconSourceChanged() {
                if (iconEffect.opacity > 0) {
                    iconSwitchAnimation.restart();
                } else {
                    iconBox.displayedSource = root.iconSource;
                }
            }
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: iconSize
            height: iconSize
            source: iconBox.displayedSource // Используем промежуточное свойство
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            sourceSize: Qt.size(iconSize * 2, iconSize * 2) // Четкость без пикселей
            visible: false
        }

        MultiEffect {
            id: iconEffect
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: iconMouse.containsMouse ? ThemeColor.primary : ThemeColor.on_surface

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

            onClicked: {
                root.iconClicked();
                root.interacted();
            }
        }
    }

    Rectangle {
        id: track
        width: trackDefaultWidth
        Layout.preferredHeight: trackHeight
        Layout.alignment: Qt.AlignVCenter
        radius: height / 2
        color: ThemeColor.surface_container_high
        clip: true

        Rectangle {
            height: parent.height
            width: parent.width * root.visualValue
            radius: parent.radius
            color: ThemeColor.primary
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
        Layout.preferredWidth: textWidth
        Layout.alignment: Qt.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.clampedValue * 100) + "%"
        color: ThemeColor.on_surface
        font {
            family: Theme.font
            pixelSize: 13
        }
    }
}
