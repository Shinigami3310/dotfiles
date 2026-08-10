import QtQuick
import "../../services"
import "../../theme"

FocusScope {
    id: root

    signal closeRequested

    implicitWidth: AppLauncherConfig.baseWidth + (AppLauncherConfig.windowPadding * 2)

    readonly property int targetSurfaceHeight: layout.implicitHeight + (AppLauncherConfig.windowPadding * 2)

    // При росте списка расширяемся сразу, при сжатии — с задержкой.
    // Иначе при каждом удалении символа окно «дёргается» вверх-вниз.
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
        interval: AppLauncherConfig.resizeDebounceInterval
        onTriggered: root.implicitHeight = root.targetSurfaceHeight
    }

    onVisibleChanged: {
        if (visible)
            searchBar.forceFocus();
    }

    Rectangle {
        anchors.fill: parent
        color: ThemeColor.surface
        radius: AppLauncherConfig.windowRadius
        border {
            color: ThemeColor.outline_variant
            width: AppLauncherConfig.windowBorderWidth
        }
    }

    Column {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: AppLauncherConfig.windowPadding
        }
        spacing: AppLauncherConfig.layoutSpacing

        SearchBar {
            id: searchBar
            width: parent.width

            onTextChanged: AppService.filter(text)
            onDownPressed: appList.moveDown()
            onUpPressed: appList.moveUp()
            onEnterPressed: appList.launchCurrent()
            onEscapePressed: root.closeRequested()
        }

        AppList {
            id: appList
            width: parent.width
            model: AppService.filteredApps

            onLaunchRequested: app => {
                AppService.launchApp(app);
                root.closeRequested();
            }
        }
    }
}
