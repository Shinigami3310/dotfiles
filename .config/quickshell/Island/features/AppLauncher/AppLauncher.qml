import QtQuick
import "../../services"
import "../../theme"

FocusScope {
    id: root

    // Динамический размер окна: передается Wayland-поверхности в Quickshell
    implicitWidth: Configs.appLauncherWidth + (Configs.appLauncherPadding * 2)
    implicitHeight: layout.implicitHeight + (Configs.appLauncherPadding * 2)

    AppService {
        id: appService
    }
    signal closeRequested

    function focusSearch() {
        searchBar.forceFocus();
    }

    onVisibleChanged: {
        if (visible)
            focusSearch();
    }

    // Фон поверхности
    Rectangle {
        anchors.fill: parent
        color: Theme.panelBg
        radius: 12
        border.color: Theme.separator
        border.width: 1
    }

    // Контент привязан к ВЕРХУ окна
    Column {
        id: layout
        anchors.top: parent.top
        anchors.topMargin: Configs.appLauncherPadding
        anchors.left: parent.left
        anchors.leftMargin: Configs.appLauncherPadding
        anchors.right: parent.right
        anchors.rightMargin: Configs.appLauncherPadding
        spacing: Configs.appLauncherSpacing

        SearchBar {
            id: searchBar
            width: parent.width
            height: Configs.appSearchHeight
            focus: true

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

            onLaunchRequested: execCommand => {
                appService.launchApp(execCommand);
                root.closeRequested();
            }
        }
    }
}
