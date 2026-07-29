import QtQuick
import QtQuick.Layouts
import "../../config"
import "../../services/"

Rectangle {
    id: root

    property QtObject notificationData
    property NotificationService service

    signal dismissRequested
    signal actionInvoked(string actionKey)

    width: 360
    radius: 12
    color: Colors.panel

    readonly property bool hasSummary: notificationData?.summary !== "" && notificationData?.summary !== notificationData?.text
    readonly property var actions: {
        try {
            return JSON.parse(notificationData?.actionsJson || "[]");
        } catch (e) {
            return [];
        }
    }
    readonly property bool hasActions: actions.length > 0

    implicitHeight: 18 + (hasSummary ? summaryText.contentHeight + 6 : 0) + mainText.contentHeight + (hasActions ? 34 : 0) + 24

    border.width: 1.5
    border.color: {
        if (!notificationData)
            return Colors.borderNormal;
        switch (notificationData.importance) {
        case Constants.importance.critical:
            return Colors.borderCritical;
        case Constants.importance.low:
            return Colors.borderLow;
        default:
            return Colors.borderNormal;
        }
    }

    MouseArea {
        id: outerArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        hoverEnabled: true
        onEntered: service?.pauseTimer(notificationData?.id)
        onExited: service?.resumeTimer(notificationData?.id)
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                dismissRequested();
        }
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
                visible: notificationData?.icon !== ""
                source: notificationData?.icon ?? ""
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
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
                    hoverEnabled: false
                    onClicked: dismissRequested()
                }
            }
        }

        Text {
            id: summaryText
            visible: hasSummary
            width: parent.width
            anchors.top: headerRow.bottom
            anchors.topMargin: 6
            text: notificationData?.summary ?? ""
            color: Colors.text
            font.pixelSize: 13
            font.bold: true
            wrapMode: Text.Wrap
        }

        Text {
            id: mainText
            width: parent.width
            anchors.top: hasSummary ? summaryText.bottom : headerRow.bottom
            anchors.topMargin: 6
            text: notificationData?.text ?? ""
            color: Colors.text
            font.pixelSize: 12
            wrapMode: Text.Wrap
        }

        RowLayout {
            id: actionsRow
            visible: hasActions
            width: parent.width
            anchors.top: mainText.bottom
            anchors.topMargin: 8
            spacing: 8

            Repeater {
                model: actions
                delegate: Rectangle {
                    required property var modelData
                    visible: modelData.key !== ""
                    implicitWidth: actionText.implicitWidth + 20
                    implicitHeight: 26
                    radius: 6
                    color: btnArea.containsMouse ? Colors.surfaceContainer : Colors.surfaceVariant
                    border.width: 1
                    border.color: btnArea.containsMouse ? Colors.primary : Colors.outlineVariant

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
                        cursorShape: Qt.PointingHandCursor
                        onClicked: actionInvoked(modelData.key)
                    }
                }
            }
        }
    }
}
