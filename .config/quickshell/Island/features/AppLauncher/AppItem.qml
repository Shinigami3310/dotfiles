import QtQuick
import "../../shared/theme"

Rectangle {
    id: root

    property string appName: ""
    property string appIcon: ""
    property bool isCurrent: false

    signal clicked

    width: ListView.view ? ListView.view.width : AppLauncherConfig.baseWidth
    height: AppLauncherConfig.itemHeight
    radius: AppLauncherConfig.itemRadius

    color: isCurrent || hoverHandler.hovered ? ThemeColor.surface_container_high : ThemeColor.transparent
    border {
        width: isCurrent ? AppLauncherConfig.itemActiveBorderWidth : 0
        color: ThemeColor.primary
    }

    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Row {
        anchors {
            fill: parent
            leftMargin: AppLauncherConfig.itemHorizontalPadding
            rightMargin: AppLauncherConfig.itemHorizontalPadding
        }
        spacing: AppLauncherConfig.itemSpacing

        Image {
            id: iconImg
            anchors.verticalCenter: parent.verticalCenter
            width: AppLauncherConfig.itemIconSize
            height: AppLauncherConfig.itemIconSize
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit
            asynchronous: true

            source: {
                if (!root.appIcon)
                    return "";
                return root.appIcon.startsWith("/") ? ("file://" + root.appIcon) : ("image://icon/" + root.appIcon);
            }

            Rectangle {
                anchors.fill: parent
                radius: AppLauncherConfig.itemIconRadius
                color: root.isCurrent ? ThemeColor.surface_container_highest : ThemeColor.surface_container_high
                visible: iconImg.status === Image.Error || iconImg.status === Image.Null || !root.appIcon
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - iconImg.width - parent.spacing
            text: root.appName
            color: root.isCurrent ? ThemeColor.primary : ThemeColor.on_surface
            elide: Text.ElideRight
            font {
                family: Theme.font
                pixelSize: AppLauncherConfig.itemTextSize
            }

            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeStandard
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: root.clicked()
    }
}
