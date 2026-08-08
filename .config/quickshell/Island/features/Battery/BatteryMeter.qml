import QtQuick
import "../../theme"
import "../../services"

// Индикатор батареи: рамка с терминалом, fill-заливка и анимация зарядки.
Item {
    id: root

    property real displayPercent: 0
    property bool isCharging: false

    width: BatteryConfig.frameWidth
    height: BatteryConfig.frameHeight

    Rectangle {
        id: batteryFrame
        anchors {
            fill: parent
            rightMargin: BatteryConfig.terminalWidth + 1
        }
        radius: BatteryConfig.frameRadius
        color: ThemeColor.transparent
        border {
            color: ThemeColor.on_surface
            width: BatteryConfig.borderWidth
        }

        Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: BatteryConfig.innerMargin
            }

            width: Math.max(0, (parent.width - (BatteryConfig.innerMargin * 2)) * (root.displayPercent / 100))
            radius: BatteryConfig.indicatorRadius
            color: root.isCharging ? ThemeColor.primary : ThemeColor.secondary

            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                }
            }
        }
    }

    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        width: BatteryConfig.terminalWidth
        height: BatteryConfig.terminalHeight
        radius: BatteryConfig.terminalRadius
        color: ThemeColor.on_surface
    }
}