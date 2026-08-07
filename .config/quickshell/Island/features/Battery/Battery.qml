import QtQuick
import "../../services"
import "../../theme"

// Поверхность профиля батареи. Удерживает синглтон BatteryService «в awake»:
// пока поверхность открыта, мониторинг udev и опрос активны; при выгрузке
// поверхности (release) сервис засыпает и не тратит ресурсы.
Item {
    id: root

    Component.onCompleted: BatteryService.retain()
    Component.onDestruction: BatteryService.release()

    implicitWidth: layout.implicitWidth + BatteryConfig.layoutPadding
    implicitHeight: layout.implicitHeight + BatteryConfig.layoutPadding

    property real chargeAnimVal: 0
    readonly property real displayPercent: BatteryService.isCharging ? chargeAnimVal : BatteryService.percent

    NumberAnimation on chargeAnimVal {
        id: chargeAnim
        from: BatteryService.percent
        to: 100
        duration: BatteryConfig.chargeAnimDuration
        loops: Animation.Infinite
    }

    Connections {
        target: BatteryService
        function onIsChargingChanged() {
            if (BatteryService.isCharging) {
                // Перезапускаем анимацию с текущего процента при каждом включении зарядки
                chargeAnim.from = BatteryService.percent;
                chargeAnimVal = BatteryService.percent;
                chargeAnim.restart();
            } else {
                chargeAnim.stop();
                chargeAnimVal = 0;
            }
        }
        function onPercentChanged() {
            if (BatteryService.isCharging) {
                chargeAnim.from = BatteryService.percent;
                chargeAnimVal = BatteryService.percent;
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
                        color: BatteryService.isCharging ? ThemeColor.primary : ThemeColor.secondary

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
                text: `${BatteryService.percent}%`
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
            }
            ProfileButton {
                profileId: "balanced"
                iconSource: "../../assets/icons/Balance.png"
            }
            ProfileButton {
                profileId: "performance"
                iconSource: "../../assets/icons/Turbo.png"
            }
        }
    }
}
