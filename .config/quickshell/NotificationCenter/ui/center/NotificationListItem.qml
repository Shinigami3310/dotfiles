import QtQuick
import QtQuick.Layouts
import "../../config"

Rectangle {
    id: root

    property QtObject notificationData
    signal dismissRequested
    signal actionInvoked(string actionKey)

    implicitHeight: contentColumn.implicitHeight + 18
    radius: 10
    color: Colors.panelAlt

    readonly property var actions: {
        try {
            return JSON.parse(notificationData?.actionsJson || "[]");
        } catch (e) {
            return [];
        }
    }

    border.width: 1
    border.color: {
        if (!notificationData)
            return Colors.outlineVariant;
        switch (notificationData.importance) {
        case Constants.importance.critical:
            return Colors.borderCritical;
        case Constants.importance.low:
            return Colors.borderLow;
        default:
            return Colors.borderNormal;
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Image {
                visible: notificationData?.icon !== ""
                source: notificationData?.icon ?? ""
                Layout.preferredWidth: 14
                Layout.preferredHeight: 14
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                onStatusChanged: {
                    if (status === Image.Error)
                        source = "";
                }
            }
            Text {
                text: notificationData?.source ?? ""
                color: Colors.muted
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: notificationData?.time ? Qt.formatTime(notificationData.time, "hh:mm") : ""
                color: Colors.muted
                font.pixelSize: 10
            }
            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: closeArea.containsMouse ? Colors.surfaceContainer : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 10
                    color: Colors.muted
                }
                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: false
                    onClicked: dismissRequested()
                }
            }
        }

        Text {
            visible: notificationData?.summary !== "" && notificationData?.summary !== notificationData?.text
            Layout.fillWidth: true
            text: notificationData?.summary ?? ""
            color: Colors.text
            font.pixelSize: 12
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            Layout.fillWidth: true
            text: notificationData?.text ?? ""
            color: Colors.text
            wrapMode: Text.Wrap
            font.pixelSize: 12
        }

        RowLayout {
            id: actionsRow
            visible: actions.length > 0
            Layout.fillWidth: true
            spacing: 6
            Layout.topMargin: 4

            Repeater {
                model: actions
                delegate: Rectangle {
                    required property var modelData
                    implicitWidth: actionText.implicitWidth + 16
                    implicitHeight: 22
                    radius: 6
                    color: btnArea.containsMouse ? Colors.surfaceContainer : Colors.surface
                    border.width: 1
                    border.color: Colors.outlineVariant

                    Text {
                        id: actionText
                        anchors.centerIn: parent
                        text: modelData.text || modelData.key
                        color: Colors.primary
                        font.pixelSize: 11
                        font.bold: true
                    }
                    MouseArea {
                        id: btnArea
                        anchors.fill: parent
                        hoverEnabled: false
                        onClicked: actionInvoked(modelData.key)
                    }
                }
            }
        }
    }
}
