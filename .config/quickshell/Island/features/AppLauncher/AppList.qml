import QtQuick
import "../../theme"

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

    ListView {
        id: listView
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        spacing: AppLauncherConfig.listSpacing

        onCountChanged: {
            if (count > 0 && currentIndex === -1) {
                currentIndex = 0;
            }
        }

        add: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Motion.morph
            }
            NumberAnimation {
                property: "y"
                from: AppLauncherConfig.listAnimOffsetY
                duration: Motion.morph
                easing.type: Easing.OutQuart
            }
        }

        remove: Transition {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: Motion.morph
            }
        }

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Motion.morph
                easing.type: Easing.OutQuart
            }
        }

        delegate: AppItem {
            appName: model.name
            appIcon: model.icon
            appExec: model.exec
            isCurrent: ListView.isCurrentItem

            onClicked: {
                listView.currentIndex = index;
                root.launchRequested(model);
            }
        }
    }
}
