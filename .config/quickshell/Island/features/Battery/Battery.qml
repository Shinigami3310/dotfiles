import QtQuick
import "../../services"
import "../../theme"

Item {
    id: root

    implicitWidth: layout.implicitWidth + Configs.batteryLayoutPadding
    implicitHeight: layout.implicitHeight + Configs.batteryLayoutPadding

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
        spacing: Configs.batteryLayoutSpacing

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Configs.batteryHeaderSpacing

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: Configs.batteryFrameWidth
                height: Configs.batteryFrameHeight

                Rectangle {
                    id: batteryFrame
                    anchors {
                        fill: parent
                        rightMargin: Configs.batteryTerminalWidth + 1
                    }
                    radius: Configs.batteryFrameRadius
                    color: "transparent"
                    border {
                        color: Theme.text
                        width: Configs.batteryBorderWidth
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: Configs.batteryInnerMargin
                        }

                        width: Math.max(0, (parent.width - (Configs.batteryInnerMargin * 2)) * (root.displayPercent / 100))
                        radius: Configs.batteryIndicatorRadius
                        color: batteryService.isCharging ? Theme.accent : Theme.text

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
                    width: Configs.batteryTerminalWidth
                    height: Configs.batteryTerminalHeight
                    radius: Configs.batteryTerminalRadius
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
            spacing: Configs.batteryProfileSpacing

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
