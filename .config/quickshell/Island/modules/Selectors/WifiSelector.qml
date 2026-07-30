import QtQuick
import QtQuick.Layouts
import "../../Singletons/"
import "../../services/Demons/"

Item {
    id: root

    implicitWidth: 320
    implicitHeight: layout.implicitHeight + 32

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Theme.panelBg
        border.color: Theme.panelBorder
        border.width: 1
    }

    Column {
        id: layout
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        spacing: 16

        RowLayout {
            width: parent.width
            spacing: 12

            Image {
                source: Qt.resolvedUrl("../../assets/icons/wifi.svg")
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: WifiService.enabled ? 1.0 : 0.5
            }

            Text {
                text: "Wi-Fi"
                font.family: Theme.font
                font.pixelSize: 16
                font.bold: true
                color: Theme.text
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Switch {
                checked: WifiService.enabled
                onToggled: WifiService.toggle()
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Item {
            id: listContainer
            width: parent.width
            implicitHeight: height
            clip: true

            state: WifiService.enabled ? "visible" : "hidden"

            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: listContainer
                        height: Math.min(listView.contentHeight, 300)
                        opacity: 1.0
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: listContainer
                        height: 0
                        opacity: 0.0
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        NumberAnimation {
                            target: listContainer
                            property: "opacity"
                            duration: Motion.fast
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: listContainer
                            property: "height"
                            duration: Motion.fast
                            easing.type: Easing.OutQuad
                        }
                    }
                },
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        NumberAnimation {
                            target: listContainer
                            property: "height"
                            duration: Motion.fast
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: listContainer
                            property: "opacity"
                            duration: Motion.fast
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            ]

            ListView {
                id: listView
                anchors.fill: parent
                model: WifiService.networkModel
                spacing: 8
                boundsBehavior: Flickable.StopAtBounds

                move: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: Motion.normal
                        easing.type: Easing.OutQuart
                    }
                }
                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: Motion.normal
                        easing.type: Easing.OutQuart
                    }
                }

                delegate: SelectorItemCard {
                    name: model.ssid
                    security: model.security
                    isConnected: model.connected
                    // Чистая реактивная привязка состояния подключения
                    isConnecting: WifiService.connectingBssid === model.bssid

                    onConnectRequested: password => {
                        WifiService.connectToNetwork(model.bssid, password);
                    }
                }
            }
        }
    }
}
