import QtQuick
import QtQuick.Layouts
import "../../config"

Rectangle {
    id: root

    property var notification
    signal dismissRequested

    implicitHeight: contentColumn.implicitHeight + 18
    radius: 10
    color: Colors.panelAlt

    readonly property string notifSource: notification?.source ?? ""
    readonly property string notifSummary: notification?.summary ?? ""
    readonly property string notifText: notification?.text ?? ""
    readonly property string notifIcon: notification?.icon ?? ""

    border.width: 1
    border.color: {
        if (!notification)
            return Colors.outlineVariant;
        if (notification.importance === Constants.importance.critical)
            return Colors.borderCritical;
        if (notification.importance === Constants.importance.low)
            return Colors.borderLow;
        return Colors.borderNormal;
    }

    ColumnLayout {
        id: contentColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }
        spacing: 4

        // --- Шапка элемента (Иконка, Источник, Время, Закрыть) ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Image {
                visible: root.notification && root.notification.icon !== ""
                source: root.notification ? root.notification.icon : ""
                Layout.preferredWidth: 14
                Layout.preferredHeight: 14
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
                    hoverEnabled: true
                    onClicked: root.dismissRequested()
                }
            }
        }

        // --- Заголовок (Summary) — если есть ---
        Text {
            visible: root.notification && root.notification.summary !== "" && root.notification.summary !== root.notification.text
            Layout.fillWidth: true
            text: root.notification ? root.notification.summary : ""
            color: Colors.text
            font.pixelSize: 12
            font.bold: true
            elide: Text.ElideRight
        }

        // --- Текст сообщения ---
        Text {
            Layout.fillWidth: true
            text: root.notification ? (root.notification.text || "") : ""
            color: Colors.text
            wrapMode: Text.Wrap
            font.pixelSize: 12
        }
    }
}
