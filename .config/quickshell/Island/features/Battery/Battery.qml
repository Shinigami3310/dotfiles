import QtQuick
import "../../services"
import "../../theme"

Item {
    id: root

    implicitWidth: layout.implicitWidth + 32
    implicitHeight: layout.implicitHeight + 32

    BatteryService {
        id: batteryService
    }

    property real chargeAnimVal: 0
    readonly property real displayPercent: batteryService.isCharging ? chargeAnimVal : batteryService.percent

    NumberAnimation on chargeAnimVal {
        from: 0
        to: 100
        duration: Configs.batteryChargeAnimDuration
        loops: Animation.Infinite
        running: batteryService.isCharging
    }

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: 20

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: Configs.batteryFrameWidth
                height: Configs.batteryFrameHeight

                // Внешний контур батареи
                Rectangle {
                    id: batteryFrame
                    anchors {
                        fill: parent
                        rightMargin: 5
                    }
                    radius: 6
                    color: "transparent"
                    border {
                        color: Theme.text
                        width: 2.5
                    }

                    // Индикатор заряда
                    Rectangle {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: 3.5
                        }
                        // Вычисляем ширину в зависимости от процентов
                        width: Math.max(0, (parent.width - 7) * (root.displayPercent / 100))
                        radius: 3
                        color: batteryService.isCharging ? Theme.accent : Theme.text

                        Behavior on color {
                            ColorAnimation {
                                duration: Motion.fast
                            }
                        }
                    }
                }

                // "Клемма" батареи
                Rectangle {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    width: 4
                    height: 12
                    radius: 2
                    color: Theme.text
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: `${batteryService.percent}%`
                font {
                    family: Theme.font
                    pixelSize: Configs.batteryTextSize
                    weight: Font.Bold
                }
                color: Theme.text
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

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
