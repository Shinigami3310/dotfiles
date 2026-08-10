import QtQuick
import QtQuick.Layouts
import "../../config"
import "../../services"

Rectangle {
    id: root

    property QtObject notificationData
    property NotificationService service
    property bool showHoverPause: false
    property bool compact: false

    signal dismissRequested
    signal actionInvoked(string actionKey)

    radius: compact ? 10 : 12
    color: compact ? Colors.panelAlt : Colors.panel
    implicitHeight: contentColumn.implicitHeight + (compact ? Settings.itemPadding * 2 : 24)

    readonly property bool hasSummary: notificationData?.summary !== "" && notificationData?.summary !== notificationData?.text
    readonly property var actions: {
        try {
            return JSON.parse(notificationData?.actionsJson || "[]");
        } catch (e) {
            return [];
        }
    }
    readonly property bool hasActions: actions.length > 0

    border.width: compact ? 1 : 1.5
    border.color: {
        if (!notificationData)
            return compact ? Colors.outlineVariant : Colors.borderNormal;
        switch (notificationData.importance) {
        case Constants.Importance.Critical:
            return Colors.borderCritical;
        case Constants.Importance.Low:
            return Colors.borderLow;
        default:
            return Colors.borderNormal;
        }
    }

    MouseArea {
        id: outerArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        hoverEnabled: showHoverPause
        onEntered: if (showHoverPause) service?.pauseTimer(notificationData?.id)
        onExited: if (showHoverPause) service?.resumeTimer(notificationData?.id)
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                dismissRequested();
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: compact ? Settings.itemPadding : 12
        }
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Image {
                visible: notificationData?.icon !== ""
                source: notificationData?.icon ?? ""
                Layout.preferredWidth: compact ? 14 : 16
                Layout.preferredHeight: compact ? 14 : 16
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
                font.pixelSize: Constants.fontSmall
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: notificationData?.time ? Qt.formatTime(notificationData.time, "hh:mm") : ""
                color: Colors.muted
                font.pixelSize: Constants.fontTiny
            }
            Pressable {
                width: compact ? 16 : 18
                height: compact ? 16 : 18
                onClicked: dismissRequested()

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: parent.hovered ? Colors.surfaceContainer : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: Constants.labelClose
                        font.pixelSize: Constants.fontTiny
                        color: Colors.muted
                    }
                }
            }
        }

        Text {
            visible: hasSummary
            Layout.fillWidth: true
            text: notificationData?.summary ?? ""
            color: Colors.text
            font.pixelSize: compact ? Constants.fontMedium : Constants.fontSummary
            font.bold: true
            elide: Text.ElideRight
            wrapMode: Text.Wrap
        }

        Text {
            Layout.fillWidth: true
            text: notificationData?.text ?? ""
            color: Colors.text
            wrapMode: Text.Wrap
            font.pixelSize: Constants.fontMedium
        }

        RowLayout {
            visible: hasActions
            Layout.fillWidth: true
            spacing: compact ? 6 : 8
            Layout.topMargin: 4

            Repeater {
                model: actions
                delegate: Pressable {
                    required property var modelData
                    visible: modelData.key !== ""
                    implicitWidth: actionText.implicitWidth + (compact ? 16 : 20)
                    implicitHeight: compact ? 22 : 26
                    onClicked: actionInvoked(modelData.key)

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: parent.hovered ? Colors.surfaceContainer : (compact ? Colors.surface : Colors.surfaceVariant)
                        border.width: 1
                        border.color: parent.hovered ? Colors.primary : Colors.outlineVariant

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: modelData.text || modelData.key
                            color: Colors.primary
                            font.pixelSize: Constants.fontSmall
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}