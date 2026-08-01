import QtQuick
import QtQuick.Layouts
import "../../theme"

Item {
    id: root

    property string title: "Selector"
    property string iconSource: ""
    property bool isServiceEnabled: false
    property var listModel: null
    property Component delegate: null

    signal toggleRequested

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
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        RowLayout {
            width: parent.width
            spacing: 12

            Image {
                source: root.iconSource
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: root.isServiceEnabled ? 1.0 : 0.5
            }

            Text {
                text: root.title
                font.family: Theme.font
                font.pixelSize: 16
                font.bold: true
                color: Theme.text
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            Switch {
                checked: root.isServiceEnabled
                onToggled: root.toggleRequested()
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Item {
            id: listContainer
            width: parent.width
            height: root.isServiceEnabled ? Math.max(Math.min(listView.contentHeight, 300), 48) : 0
            opacity: root.isServiceEnabled ? 1.0 : 0.0
            clip: true

            Behavior on height {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutQuad
                }
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: root.listModel
                delegate: root.delegate
                spacing: 8
                boundsBehavior: Flickable.StopAtBounds

                move: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: Motion.standard
                        easing.type: Easing.OutQuart
                    }
                }
                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: Motion.standard
                        easing.type: Easing.OutQuart
                    }
                }
            }
        }
    }
}
