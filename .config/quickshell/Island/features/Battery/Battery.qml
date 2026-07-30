import QtQuick
import "../../services"
import "../../theme"

Item {
    id: root

    implicitWidth: layout.implicitWidth + 32
    implicitHeight: layout.implicitHeight + 32

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: 20

        // --- Строка 1: Индикатор и процент батареи ---
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            // Иконка батареи
            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: 42
                height: 22

                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 4
                    radius: 4
                    color: "transparent"
                    border.color: Theme.text
                    border.width: 2

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 4
                        width: Math.max(0, (parent.width - 8) * (BatteryService.percent / 100))
                        radius: 2
                        color: BatteryService.isCharging ? Theme.accent : Theme.text

                        Behavior on width {
                            NumberAnimation {
                                duration: Motion.standard
                                easing.type: Motion.easeStandard
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: Motion.fast
                                easing.type: Motion.easeStandard
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 4
                    height: 10
                    radius: 2
                    color: Theme.text
                }
            }

            // Текст: Процент и статус (Заряжается / Питание от батареи)
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: BatteryService.percent + "%"
                    font.family: Theme.font
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    color: Theme.text
                }

                Text {
                    text: BatteryService.isCharging ? "Заряжается" : "От батареи"
                    font.family: Theme.font
                    font.pixelSize: 12
                    color: Theme.textMuted
                }
            }
        }

        // --- Разделительная линия ---
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: layout.implicitWidth
            height: 1
            color: Theme.separator
        }

        // --- Строка 2: Кнопки профилей ---
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            ProfileButton {
                profileId: "power-saver"
                label: "Eco"
                iconSymbol: "🌱"
            }

            ProfileButton {
                profileId: "balanced"
                label: "Balance"
                iconSymbol: "⚖️"
            }

            ProfileButton {
                profileId: "performance"
                label: "Turbo"
                iconSymbol: "⚡"
            }
        }
    }
}
