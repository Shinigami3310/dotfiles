import QtQuick
import "../../services"
import "../../theme"
import "../../ui"

// Поверхность профиля батареи. Удерживает синглтон BatteryService «в awake»:
// пока поверхность открыта, мониторинг udev и опрос активны; при выгрузке
// поверхности (release) сервис засыпает и не тратит ресурсы.
Item {
    id: root

    ServiceClient { service: BatteryService }

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
                // Анимация стартует от реального процента, а не от 0 —
                // иначе при включении зарядки на 80% шкала «прыгнет» вниз.
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

            BatteryMeter {
                anchors.verticalCenter: parent.verticalCenter
                displayPercent: root.displayPercent
                isCharging: BatteryService.isCharging
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
                iconSource: "Eco.png"
            }
            ProfileButton {
                profileId: "balanced"
                iconSource: "Balance.png"
            }
            ProfileButton {
                profileId: "performance"
                iconSource: "Turbo.png"
            }
        }
    }
}