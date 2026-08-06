import QtQuick
import "../../services"
import "../../theme"

Item {
    id: root

    implicitWidth: layout.implicitWidth + BatteryConfig.layoutPadding
    implicitHeight: layout.implicitHeight + BatteryConfig.layoutPadding

    BatteryService {
        id: batteryService
    }

    property real chargeAnimVal: 0
    readonly property real displayPercent: batteryService.isCharging ? chargeAnimVal : batteryService.percent

    NumberAnimation on chargeAnimVal {
        id: chargeAnim
        from: batteryService.percent
        to: 100
        duration: BatteryConfig.chargeAnimDuration
        loops: Animation.Infinite
    }

    Connections {
        target: batteryService
        function onIsChargingChanged() {
            if (batteryService.isCharging) {
                // Перезапускаем анимацию с текущего процента при каждом включении зарядки
                chargeAnim.from = batteryService.percent;
                chargeAnimVal = batteryService.percent;
                chargeAnim.restart();
            } else {
                chargeAnim.stop();
                chargeAnimVal = 0;
            }
        }
        function onPercentChanged() {
            if (batteryService.isCharging) {
                chargeAnim.from = batteryService.percent;
                chargeAnimVal = batteryService.percent;
                chargeAnim.restart();
            }
        }
    }

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: BatteryConfig.layoutSpacing

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: BatteryConfig.headerSpacing

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: BatteryConfig.frameWidth
                height: BatteryConfig.frameHeight

                Rectangle {
                    id: batteryFrame
                    anchors {
                        fill: parent
                        rightMargin: BatteryConfig.terminalWidth + 1
                    }
                    radius: BatteryConfig.frameRadius
                    color: "transparent"
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
                        color: batteryService.isCharging ? ThemeColor.primary : ThemeColor.secondary

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

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: `${batteryService.percent}%`
                font {
                    family: Theme.font
                    pixelSize: BatteryConfig.textSize
                    weight: Font.Bold
                }
                color: ThemeColor.on_surface
                renderType: Text.NativeRendering
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: BatteryConfig.profileSpacing

            ProfileButton {
                profileId: "power-saver"
                iconSource: "../../assets/icons/Eco.png"
                service: batteryService
            }
            ProfileButton {
                profileId: "balanced"
                iconSource: "../../assets/icons/Balance.png"
                service: batteryService
            }
            ProfileButton {
                profileId: "performance"
                iconSource: "../../assets/icons/Turbo.png"
                service: batteryService
            }
        }
    }
}
