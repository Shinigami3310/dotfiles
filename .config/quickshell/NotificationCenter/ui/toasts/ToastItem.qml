import QtQuick
import QtQuick.Layouts
import "../../config"

Rectangle {
    id: root

    property var notification
    property var service

    signal dismissRequested

    width: 360

    readonly property bool hasSummary: notification && notification.summary !== "" && notification.summary !== notification.text

    implicitHeight: 18 + (hasSummary ? summaryText.contentHeight + 6 : 0) + mainText.contentHeight + 24

    radius: 12
    color: Colors.panel

    border.width: 1.5
    border.color: {
        if (!notification)
            return Colors.borderNormal;
        if (notification.importance === Constants.importance.critical)
            return Colors.borderCritical;
        if (notification.importance === Constants.importance.low)
            return Colors.borderLow;
        return Colors.borderNormal;
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton

        onEntered: if (root.service && root.notification)
            root.service.pauseTimer(root.notification.id)
        onExited: if (root.service && root.notification)
            root.service.resumeTimer(root.notification.id)

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton)
                root.dismissRequested();
        }

        Item {
            anchors {
                fill: parent
                margins: 12
            }

            RowLayout {
                id: headerRow
                width: parent.width
                height: 18
                spacing: 6

                Image {
                    visible: root.notification && root.notification.icon !== ""
                    source: root.notification ? root.notification.icon : ""
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }

                Text {
                    text: root.notification ? (root.notification.source || "") : ""
                    color: Colors.muted
                    font.pixelSize: 11
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: {
                        if (!root.notification || !root.notification.time)
                            return "";
                        var t = root.notification.time;
                        return (t instanceof Date) ? ("0" + t.getHours()).slice(-2) + ":" + ("0" + t.getMinutes()).slice(-2) : "";
                    }
                    color: Colors.muted
                    font.pixelSize: 10
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: closeArea.containsMouse ? Colors.surfaceContainer : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 10
                        color: Colors.textOnSurfaceVariant
                    }

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.dismissRequested()
                    }
                }
            }

            Text {
                id: summaryText
                visible: root.hasSummary
                width: parent.width
                anchors.top: headerRow.bottom
                anchors.topMargin: 6

                text: root.notification ? root.notification.summary : ""
                color: Colors.text
                font.pixelSize: 13
                font.bold: true
                wrapMode: Text.Wrap
            }

            Text {
                id: mainText
                width: parent.width
                anchors.top: root.hasSummary ? summaryText.bottom : headerRow.bottom
                anchors.topMargin: 6

                text: root.notification ? (root.notification.text || "") : ""
                color: Colors.text
                font.pixelSize: 12
                wrapMode: Text.Wrap
            }
        }
    }
}
