import QtQuick
import "../../services"

import "../../theme"

Rectangle {
    id: root

    property string profileId: ""
    property string label: ""
    property string iconSymbol: ""

    // Кнопка напрямую берет и отслеживает активное состояние из сервиса
    readonly property bool isActive: BatteryService.activeProfile === profileId

    implicitWidth: 64
    implicitHeight: 64
    radius: width / 2

    // Цвета и границы на основе состояния
    color: isActive ? Theme.accent : (mouseArea.containsMouse ? Theme.hover : Theme.surface2)
    border.color: isActive ? Theme.accent : "transparent"
    border.width: 1

    // Легкий зум при наведении
    scale: mouseArea.containsMouse && !isActive ? 1.05 : 1.0

    // Анимационные переходы
    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.iconSymbol !== ""
            text: root.iconSymbol
            font.family: Theme.font
            font.pixelSize: 14
            color: root.isActive ? Theme.accentText : Theme.text

            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.family: Theme.font
            font.pixelSize: 11
            font.weight: root.isActive ? Font.Bold : Font.Normal
            color: root.isActive ? Theme.accentText : Theme.text

            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (root.profileId !== "") {
                BatteryService.setProfile(root.profileId);
            }
        }
    }
}
