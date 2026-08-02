import QtQuick
import "../../theme"

Rectangle {
    id: root

    property string appName: ""
    property string appIcon: ""
    property string appExec: ""
    property bool isCurrent: false

    signal clicked

    width: ListView.view ? ListView.view.width : Configs.appLauncherWidth
    height: Configs.appListItemHeight
    radius: Configs.appListItemRadius

    color: isCurrent ? Theme.accent : (mouseArea.containsMouse ? Theme.hover : "transparent")

    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Image {
            id: iconImg
            anchors.verticalCenter: parent.verticalCenter
            width: Configs.appListIconSize
            height: Configs.appListIconSize

            // Обработка путей иконок (абсолютные или из темы иконок)
            source: {
                if (!root.appIcon)
                    return "";
                return root.appIcon.startsWith("/") ? ("file://" + root.appIcon) : ("image://icon/" + root.appIcon);
            }

            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit

            // Заглушка, если иконка не найдена
            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.isCurrent ? Theme.accentText : Theme.surface2
                visible: iconImg.status === Image.Error || iconImg.status === Image.Null || !root.appIcon

                Text {
                    anchors.centerIn: parent
                    text: root.appName ? root.appName.charAt(0).toUpperCase() : "?"
                    font {
                        family: Theme.font
                        pixelSize: 12
                        weight: Font.Bold
                    }
                    color: root.isCurrent ? Theme.accent : Theme.text
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconImg.width - parent.spacing
            text: root.appName
            font {
                family: Theme.font
                pixelSize: Configs.appListTitleSize
            }
            color: root.isCurrent ? Theme.accentText : Theme.text
            elide: Text.ElideRight

            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
