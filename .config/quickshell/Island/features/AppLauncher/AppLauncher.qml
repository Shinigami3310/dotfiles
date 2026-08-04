import QtQuick
import "../../services"
import "../../theme"

FocusScope {
    id: root

    AppService {
        id: appService
    }

    signal closeRequested

    readonly property int padding: 16
    implicitWidth: 360 + (padding * 2)

    readonly property int targetSurfaceHeight: layout.implicitHeight + (padding * 2)

    onTargetSurfaceHeightChanged: {
        if (targetSurfaceHeight > implicitHeight) {
            resizeDebounce.stop();
            implicitHeight = targetSurfaceHeight;
        } else {
            resizeDebounce.restart();
        }
    }

    Component.onCompleted: implicitHeight = targetSurfaceHeight

    Timer {
        id: resizeDebounce
        interval: 150
        onTriggered: root.implicitHeight = root.targetSurfaceHeight
    }

    onVisibleChanged: {
        if (visible)
            searchBar.forceFocus();
    }

    Rectangle {
        anchors.fill: parent
        color: ThemeColor.surface
        radius: 12
        border {
            color: ThemeColor.outline_variant
            width: 1
        }
    }

    Column {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: root.padding
        }
        spacing: 8

        SearchBar {
            id: searchBar
            width: parent.width

            onTextChanged: appService.filter(text)
            onDownPressed: appList.moveDown()
            onUpPressed: appList.moveUp()
            onEnterPressed: appList.launchCurrent()
            onEscapePressed: root.closeRequested()
        }

        AppList {
            id: appList
            width: parent.width
            model: appService.filteredApps

            onLaunchRequested: app => {
                appService.launchApp(app);
                root.closeRequested();
            }
        }
    }
}
