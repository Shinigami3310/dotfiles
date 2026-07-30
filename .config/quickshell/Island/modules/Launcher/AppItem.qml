import QtQuick
import "../../Singletons/"

Rectangle {
    id: root

    // Явные свойства вместо объекта appData
    property string appName: ""
    property string appIcon: ""
    property string appExec: ""
    property bool isCurrent: false

    signal clicked

    width: ListView.view ? ListView.view.width : 360
    height: 44
    radius: 6

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
            width: 24
            height: 24

            source: {
                if (!root.appIcon)
                    return "";
                if (root.appIcon.startsWith("/"))
                    return "file://" + root.appIcon;
                return "image://icon/" + root.appIcon;
            }
            sourceSize: Qt.size(24, 24)
            fillMode: Image.PreserveAspectFit

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.isCurrent ? Theme.accentText : Theme.surface2
                visible: iconImg.status === Image.Error || iconImg.status === Image.Null || !root.appIcon

                Text {
                    anchors.centerIn: parent
                    text: root.appName ? root.appName.charAt(0).toUpperCase() : "?"
                    font.family: Theme.font
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    color: root.isCurrent ? Theme.accent : Theme.text
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconImg.width - parent.spacing
            text: root.appName
            font.family: Theme.font
            font.pixelSize: 14
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
