import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme"

Item {
    id: root

    property string title: "Selector"
    property string iconSource: ""
    property bool isServiceEnabled: false
    property var listModel: null
    property Component delegate: null

    signal toggleRequested

    implicitWidth: SelectorConfig.width
    implicitHeight: layout.implicitHeight + (SelectorConfig.padding * 2)

    Rectangle {
        anchors.fill: parent
        radius: SelectorConfig.panelRadius
        color: ThemeColor.surface_container
        border.color: ThemeColor.outline_variant
        border.width: 1
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: SelectorConfig.padding
        spacing: SelectorConfig.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: SelectorConfig.headerSpacing

            Image {
                id: sectionIcon
                source: root.iconSource
                Layout.preferredWidth: SelectorConfig.iconSize
                Layout.preferredHeight: SelectorConfig.iconSize
                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
                visible: false // Скрыто для MultiEffect
            }

            MultiEffect {
                Layout.preferredWidth: SelectorConfig.iconSize
                Layout.preferredHeight: SelectorConfig.iconSize
                Layout.alignment: Qt.AlignVCenter
                source: sectionIcon
                colorization: 1.0
                colorizationColor: ThemeColor.on_surface
                opacity: root.isServiceEnabled ? 1.0 : SelectorConfig.iconOpacityDisabled

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
                font.pixelSize: SelectorConfig.titleFontSize
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
            Layout.fillWidth: true
            readonly property real targetHeight: Math.max(Math.min(listView.contentHeight, SelectorConfig.maxListHeight), SelectorConfig.minListHeight)
            Layout.preferredHeight: root.isServiceEnabled ? targetHeight : 0
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
                spacing: SelectorConfig.cardSpacing
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
