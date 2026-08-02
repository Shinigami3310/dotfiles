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
        anchors {
            fill: parent
            leftMargin: Configs.appListItemMargin
            rightMargin: Configs.appListItemMargin
        }
        spacing: Configs.appListItemSpacing

        Image {
            id: iconImg
            anchors.verticalCenter: parent.verticalCenter
            width: Configs.appListIconSize
            height: Configs.appListIconSize
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit

            source: {
                if (!root.appIcon)
                    return "";
                return root.appIcon.startsWith("/") ? ("file://" + root.appIcon) : ("image://icon/" + root.appIcon);
            }

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
            width: parent.width - iconImg.width - Configs.appListItemSpacing
            text: root.appName
            color: root.isCurrent ? Theme.accentText : Theme.text
            elide: Text.ElideRight
            font {
                family: Theme.font
                pixelSize: Configs.appListTitleSize
            }

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
