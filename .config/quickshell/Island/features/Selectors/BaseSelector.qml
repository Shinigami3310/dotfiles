import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme"

Item {
    id: root

    // Локальные константы
    readonly property real selectorWidth: 320
    readonly property real selectorMaxListHeight: 300
    readonly property real selectorMinListHeight: 48
    readonly property real selectorPadding: 16
    readonly property real selectorSpacing: 16
    readonly property real panelRadius: 16
    readonly property real selectorIconSize: 24
    readonly property real cardSpacing: 6

    property string title: "Selector"
    property string iconSource: ""
    property bool isServiceEnabled: false
    property var listModel: null
    property Component delegate: null

    signal toggleRequested

    implicitWidth: selectorWidth
    implicitHeight: layout.implicitHeight + (selectorPadding * 2)

    Rectangle {
        anchors.fill: parent
        radius: panelRadius
        color: ThemeColor.surface_container
        border.color: ThemeColor.outline_variant
        border.width: 1
    }

    Column {
        id: layout
        anchors.fill: parent
        anchors.margins: selectorPadding
        spacing: selectorSpacing

        RowLayout {
            width: parent.width
            spacing: 12

            Image {
                id: sectionIcon
                source: root.iconSource
                Layout.preferredWidth: selectorIconSize
                Layout.preferredHeight: selectorIconSize
                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                visible: false // Скрываем, так как используем MultiEffect
            }

            MultiEffect {
                Layout.preferredWidth: selectorIconSize
                Layout.preferredHeight: selectorIconSize
                Layout.alignment: Qt.AlignVCenter
                source: sectionIcon
                colorization: 1.0
                colorizationColor: ThemeColor.on_surface
                opacity: root.isServiceEnabled ? 1.0 : 0.5

                Behavior on opacity {
                    NumberAnimation {
                        duration: Motion.fast
                    }
                }
                Behavior on colorizationColor {
                    ColorAnimation {
                        duration: Motion.fast
                    }
                }
            }

            Text {
                text: root.title
                font.family: Theme.font
                font.pixelSize: 16
                font.bold: true
                color: ThemeColor.on_surface
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
            height: root.isServiceEnabled ? Math.max(Math.min(listView.contentHeight, selectorMaxListHeight), selectorMinListHeight) : 0
            opacity: root.isServiceEnabled ? 1.0 : 0.0
            visible: opacity > 0
            clip: true

            Behavior on height {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutCubic
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
                spacing: cardSpacing
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
