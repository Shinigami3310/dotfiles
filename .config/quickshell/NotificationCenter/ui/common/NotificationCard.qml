import QtQuick
import QtQuick.Layouts
import "../common"
import "../../config"
import "../../services"

Rectangle {
    property var notificationData
    property NotificationService service
    property bool showHoverPause: false
    property bool compact: false

    signal dismissRequested
    signal actionInvoked(string actionKey)

    radius: compact ? CommonConfig.cardRadiusCompact : CommonConfig.cardRadius
    color: compact ? Colors.panelAlt : Colors.panel
    implicitHeight: contentColumn.implicitHeight + (compact ? CommonConfig.cardPaddingCompact : CommonConfig.cardVPadding) * 2

    readonly property bool hasSummary: notificationData?.summary !== "" && notificationData?.summary !== notificationData?.text
    readonly property var actions: {
        try {
            return JSON.parse(notificationData?.actionsJson || "[]");
        } catch (e) {
            return [];
        }
    }
    readonly property bool hasActions: actions.length > 0

    border.width: compact ? CommonConfig.cardBorderWidthCompact : CommonConfig.cardBorderWidth
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

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: dismissRequested()
    }

    HoverHandler {
        enabled: showHoverPause
        onHoveredChanged: if (showHoverPause) {
            if (hovered)
                service?.pauseTimer(notificationData?.id)
            else
                service?.resumeTimer(notificationData?.id)
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: compact ? CommonConfig.cardPaddingCompact : CommonConfig.cardPadding
        }
        spacing: CommonConfig.contentSpacing

        RowLayout {
            Layout.fillWidth: true
            spacing: CommonConfig.contentSpacing

            Image {
                visible: notificationData?.icon !== ""
                source: notificationData?.icon ?? ""
                Layout.preferredWidth: compact ? CommonConfig.iconSizeCompact : CommonConfig.iconSize
                Layout.preferredHeight: compact ? CommonConfig.iconSizeCompact : CommonConfig.iconSize
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                onStatusChanged: if (status === Image.Error) source = ""
            }
            Text {
                text: notificationData?.source ?? ""
                color: Colors.muted
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontSmall
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: notificationData?.time ? Qt.formatTime(notificationData.time, "hh:mm") : ""
                color: Colors.muted
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontTiny
            }
            Pressable {
                width: compact ? CommonConfig.closeButtonSizeCompact : CommonConfig.closeButtonSize
                height: compact ? CommonConfig.closeButtonSizeCompact : CommonConfig.closeButtonSize
                onClicked: dismissRequested()

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: parent.hovered ? Colors.surfaceContainer : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: Constants.labelClose
                        font.family: Constants.fontFamily
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
            font.family: Constants.fontFamily
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
            font.family: Constants.fontFamily
            font.pixelSize: Constants.fontMedium
        }

        RowLayout {
            visible: hasActions
            Layout.fillWidth: true
            spacing: compact ? CommonConfig.contentSpacing : CommonConfig.contentSpacing + 2
            Layout.topMargin: 4

            Repeater {
                model: actions
                delegate: Pressable {
                    required property var modelData
                    visible: modelData.key !== ""
                    implicitWidth: actionText.implicitWidth + (compact ? CommonConfig.actionHPaddingCompact : CommonConfig.actionHPadding)
                    implicitHeight: compact ? CommonConfig.actionHeightCompact : CommonConfig.actionHeight
                    onClicked: actionInvoked(modelData.key)

                    Rectangle {
                        anchors.fill: parent
                        radius: CommonConfig.actionRadius
                        border.width: CommonConfig.actionBorderWidth
                        color: parent.hovered ? Colors.surfaceContainer : (compact ? Colors.surface : Colors.surfaceVariant)
                        border.color: parent.hovered ? Colors.primary : Colors.outlineVariant

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: modelData.text || modelData.key
                            color: Colors.primary
                            font.family: Constants.fontFamily
                            font.pixelSize: Constants.fontSmall
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
