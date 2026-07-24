import Quickshell
import QtQuick
import "core"
import "Singletons"

PanelWindow {
    id: root

    anchors.top: true
    margins.top: 10
    exclusiveZone: 0
    color: "transparent"

    implicitWidth: switcher.maxExpandedWidth
    implicitHeight: switcher.maxExpandedHeight

    mask: Region {
        item: island
    }

    IslandFrame {
        id: island

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: switcher.currentWidth
        implicitHeight: switcher.currentHeight

        backgroundColor: Theme.panelBg

        IslandTransition {
            id: switcher
            anchors.fill: parent
            expanded: hover.containsMouse
            collapsedComponent: clockComponent
            expandedComponent: barComponent
        }

        MouseArea {
            id: hover
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    Component {
        id: clockComponent
        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm")
            font.family: Theme.font
            font.pixelSize: 18
            font.weight: Font.Medium
            color: Theme.text
            antialiasing: true
        }
    }
    Component {
        id: barComponent
        Item {
            id: barRoot

            // ---- Настраиваемые параметры ----
            property real dotSize: 8
            property int dotCount: 5
            property real iconSize: 22
            property int iconCount: 5
            property real iconSpacing: 8
            property real spacingBetweenBlocks: 14   // расстояние между левым блоком, часами и правым

            // ---- Вычисляем минимальные ширины ----
            property real leftMinWidth: dotCount * dotSize
            property real rightMinWidth: iconCount * iconSize + (iconCount - 1) * iconSpacing
            property real sideWidth: Math.max(leftMinWidth, rightMinWidth)   // одинаковая для обеих сторон

            // ---- Явные размеры компонента (для Loader) ----
            property real clockWidth: clockColumn.implicitWidth
            implicitWidth: sideWidth * 2 + clockWidth + spacingBetweenBlocks * 2
            implicitHeight: Math.max(dotSize, clockColumn.implicitHeight, iconSize)

            // ---- Левый блок: точки распределены равномерно ----
            Item {
                id: leftContainer
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: barRoot.sideWidth
                height: barRoot.dotSize

                Repeater {
                    model: barRoot.dotCount
                    Rectangle {
                        // каждая точка занимает позицию от 0 до width - dotSize
                        x: index * (leftContainer.width - barRoot.dotSize) / (barRoot.dotCount - 1)
                        y: (leftContainer.height - height) / 2
                        width: barRoot.dotSize
                        height: barRoot.dotSize
                        radius: width / 2
                        color: Theme.textMuted
                        opacity: 0.55
                    }
                }
            }

            // ---- Центральный блок: часы ----
            Column {
                id: clockColumn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: Qt.formatDateTime(clock.date, "hh:mm")
                    font.family: Theme.font
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    color: Theme.text
                    antialiasing: true
                }

                Text {
                    text: Qt.formatDateTime(clock.date, "ddd dd MMM").toUpperCase()
                    font.family: Theme.font
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    color: Theme.textMuted
                    antialiasing: true
                }
            }

            // ---- Правый блок: иконки (группированы справа) ----
            Item {
                id: rightContainer
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: barRoot.sideWidth
                height: barRoot.iconSize

                Row {
                    id: iconsRow
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: barRoot.iconSpacing

                    Repeater {
                        model: barRoot.iconCount
                        delegate: Rectangle {
                            width: barRoot.iconSize
                            height: barRoot.iconSize
                            radius: width / 2
                            color: Theme.surface2
                            border.width: 1
                            border.color: Theme.separator

                            Text {
                                anchors.centerIn: parent
                                text: ["E", "P", "S", "B", "⏻"][index]
                                font.family: Theme.font
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                color: Theme.textMuted
                                antialiasing: true
                            }
                        }
                    }
                }
            }
        }
    }
}
