import QtQuick
import "../../services"
import "../../theme"

Item {
    id: root

    readonly property int layoutPadding: 52
    readonly property int layoutSpacing: 20
    readonly property int headerSpacing: 16
    readonly property int profileSpacing: 12

    readonly property int frameRadius: 6
    readonly property real borderWidth: 2.5
    readonly property real innerMargin: 3.5
    readonly property int indicatorRadius: 3

    readonly property int terminalWidth: 4
    readonly property int terminalHeight: 12
    readonly property int terminalRadius: 2

    readonly property int frameWidth: 62
    readonly property int frameHeight: 32
    readonly property int textSize: 28

    readonly property int chargeAnimDuration: 2700

    implicitWidth: layout.implicitWidth + layoutPadding
    implicitHeight: layout.implicitHeight + layoutPadding

    BatteryService {
        id: batteryService
    }

    property real chargeAnimVal: 0
    readonly property real displayPercent: batteryService.isCharging ? chargeAnimVal : batteryService.percent

    NumberAnimation on chargeAnimVal {
        from: 0
        to: 100
        duration: chargeAnimDuration
        loops: Animation.Infinite
        running: batteryService.isCharging
    }

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: layoutSpacing

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: headerSpacing

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: frameWidth
                height: frameHeight

                Rectangle {
                    id: batteryFrame
                    anchors {
                        fill: parent
                        rightMargin: terminalWidth + 1
                    }
                    radius: frameRadius
                    color: "transparent"
                    border {
                        color: ThemeColor.on_surface
                        width: borderWidth
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: innerMargin
                        }

                        width: Math.max(0, (parent.width - (innerMargin * 2)) * (root.displayPercent / 100))
                        radius: indicatorRadius
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
                    width: terminalWidth
                    height: terminalHeight
                    radius: terminalRadius
                    color: ThemeColor.on_surface
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: `${batteryService.percent}%`
                font {
                    family: Theme.font
                    pixelSize: textSize
                    weight: Font.Bold
                }
                color: ThemeColor.on_surface
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: profileSpacing

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
