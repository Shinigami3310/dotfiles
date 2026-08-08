import QtQuick
import "../../ui"

// Список приложений. Первый элемент выбирается автоматически, чтобы Enter
// сразу запускал топ-результат — иначе нужно лишнее нажатие вниз.
Item {
    id: root

    property alias model: listView.model

    signal launchRequested(var app)

    implicitHeight: Math.min(listView.contentHeight, AppLauncherConfig.listMaxHeight)
    clip: true

    function moveDown() {
        listView.incrementCurrentIndex();
    }
    function moveUp() {
        listView.decrementCurrentIndex();
    }

    function launchCurrent() {
        if (listView.currentItem && listView.model && listView.count > listView.currentIndex) {
            root.launchRequested(listView.model.get(listView.currentIndex));
        }
    }

    AnimatedList {
        id: listView
        anchors.fill: parent
        spacing: AppLauncherConfig.listSpacing
        addOffset: AppLauncherConfig.listAnimOffsetY

        onCountChanged: {
            if (count > 0 && currentIndex === -1) {
                currentIndex = 0;
            }
        }

        delegate: AppItem {
            appName: model.name
            appIcon: model.icon
            isCurrent: ListView.isCurrentItem

            onClicked: {
                listView.currentIndex = index;
                root.launchRequested(model);
            }
        }
    }
}