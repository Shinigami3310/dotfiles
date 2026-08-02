import QtQuick
import "../../theme"

Item {
    id: root

    property alias model: listView.model
    property int maxHeight: Configs.appListMaxHeight

    signal launchRequested(string execCommand)

    // Вычисляем целевую высоту списка
    readonly property int targetHeight: Math.min(listView.contentHeight, maxHeight)

    // Привязываем и внешнюю (height), и неявную (implicitHeight) высоту
    implicitHeight: targetHeight
    height: implicitHeight

    clip: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutQuart
        }
    }

    function moveDown() {
        listView.incrementCurrentIndex();
    }

    function moveUp() {
        listView.decrementCurrentIndex();
    }

    function launchCurrent() {
        if (listView.currentItem && listView.model && listView.count > listView.currentIndex) {
            root.launchRequested(listView.model.get(listView.currentIndex).exec);
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        spacing: 2

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
                duration: Motion.standard
            }
            NumberAnimation {
                property: "y"
                from: -20
                duration: Motion.standard
                easing.type: Easing.OutQuart
            }
        }

        remove: Transition {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: Motion.standard
            }
        }

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Motion.standard
                easing.type: Easing.OutQuart
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Motion.standard
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
                root.launchRequested(model.exec);
            }
        }
    }
}
