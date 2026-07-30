import QtQuick
import "../../services"
import "../../theme"

FocusScope {
    id: root

    readonly property int padding: 16
    readonly property int searchBarHeight: 48
    readonly property int maxListHeight: 360
    readonly property int spacing: 8

    // 1. Динамический размер окна: передается Wayland-поверхности в Quickshell
    implicitWidth: 360 + (padding * 2)
    implicitHeight: layout.implicitHeight + (padding * 2)

    signal closeRequested

    function focusSearch() {
        searchBar.forceFocus();
    }

    onVisibleChanged: {
        if (visible)
            focusSearch();
    }

    // 2. Фон всегда точно соответствует размеру Surface
    Rectangle {
        anchors.fill: parent
        color: Theme.panelBg
        radius: 12
        border.color: Theme.separator
        border.width: 1
    }

    // 3. Контент жестко привязан к ВЕРХУ окна.
    // SearchBar остается на месте, а расширение/сжатие идет вниз.
    Column {
        id: layout
        anchors.top: parent.top
        anchors.topMargin: root.padding
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.right: parent.right
        anchors.rightMargin: root.padding
        spacing: root.spacing

        SearchBar {
            id: searchBar
            width: parent.width
            height: root.searchBarHeight
            focus: true

            onTextChanged: AppService.filter(text)
            onDownPressed: appList.moveDown()
            onUpPressed: appList.moveUp()
            onEnterPressed: appList.launchCurrent()
            onEscapePressed: root.closeRequested()
        }

        AppList {
            id: appList
            width: parent.width
            maxHeight: root.maxListHeight
            model: AppService.filteredApps

            onLaunchRequested: execCommand => {
                AppService.launchApp(execCommand);
                root.closeRequested();
            }
        }
    }
}
