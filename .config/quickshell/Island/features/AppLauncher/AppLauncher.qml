import QtQuick
import "../../services"
import "../../theme"

FocusScope {
    id: root

    AppService {
        id: appService
    }

    signal closeRequested

    implicitWidth: Configs.appLauncherWidth + (Configs.appLauncherPadding * 2)

    readonly property int targetSurfaceHeight: layout.implicitHeight + (Configs.appLauncherPadding * 2)

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
        interval: Configs.appLauncherDebounceDelay
        onTriggered: root.implicitHeight = root.targetSurfaceHeight
    }

    onVisibleChanged: {
        if (visible)
            searchBar.forceFocus();
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.panelBg
        radius: 12
        border {
            color: Theme.separator
            width: 1
        }
    }

    Column {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Configs.appLauncherPadding
        }
        spacing: Configs.appLauncherSpacing

        SearchBar {
            id: searchBar
            width: parent.width
            height: Configs.appSearchHeight

            onTextChanged: appService.filter(text)
            onDownPressed: appList.moveDown()
            onUpPressed: appList.moveUp()
            onEnterPressed: appList.launchCurrent()
            onEscapePressed: root.closeRequested()
        }

        AppList {
            id: appList
            width: parent.width
            maxHeight: Configs.appListMaxHeight
            model: appService.filteredApps

            onLaunchRequested: app => {
                appService.launchApp(app);
                root.closeRequested();
            }
        }
    }
}
