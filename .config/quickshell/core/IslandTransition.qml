import QtQuick
import "../Singletons"

Item {
    id: root

    property bool expanded: false
    property Component collapsedComponent
    property Component expandedComponent

    property int fadeDuration: Motion.fade

    property bool _showExpanded: false
    property bool _queuedExpanded: false
    property bool _busy: false

    property Item _fromLoader: null
    property Item _toLoader: null

    readonly property int collapsedWidth: collapsedLoader.item ? collapsedLoader.item.implicitWidth : 0
    readonly property int collapsedHeight: collapsedLoader.item ? collapsedLoader.item.implicitHeight : 0

    readonly property int expandedWidth: expandedLoader.item ? expandedLoader.item.implicitWidth : 0
    readonly property int expandedHeight: expandedLoader.item ? expandedLoader.item.implicitHeight : 0

    implicitWidth: _showExpanded ? expandedWidth : collapsedWidth
    implicitHeight: _showExpanded ? expandedHeight : collapsedHeight

    Loader {
        id: collapsedLoader
        anchors.centerIn: parent
        sourceComponent: root.collapsedComponent
        visible: opacity > 0
    }

    Loader {
        id: expandedLoader
        anchors.centerIn: parent
        sourceComponent: root.expandedComponent
        visible: opacity > 0
    }

    PropertyAnimation {
        id: fadeOut
        target: null
        property: "opacity"
        to: 0
        duration: root.fadeDuration
        easing.type: Easing.InOutQuad

        onStopped: {
            if (!root._busy)
                return;
            root._showExpanded = root._queuedExpanded;
            delayTimer.start();
        }
    }

    Timer {
        id: delayTimer
        interval: Motion.expand
        running: false
        repeat: false
        onTriggered: {
            if (root._queuedExpanded !== root._showExpanded) {
                root._busy = false;
                Qt.callLater(root._sync);
                return;
            }
            if (root._toLoader) {
                fadeIn.target = root._toLoader;
                fadeIn.restart();
            }
        }
    }

    PropertyAnimation {
        id: fadeIn
        target: null
        property: "opacity"
        to: 1
        duration: root.fadeDuration
        easing.type: Easing.InOutQuad

        onStopped: {
            root._busy = false;
            if (root._queuedExpanded !== root._showExpanded)
                Qt.callLater(root._sync);
        }
    }

    function _sync() {
        root._queuedExpanded = root.expanded;
        if (root._busy)
            return;
        if (root._queuedExpanded === root._showExpanded)
            return;

        root._busy = true;
        // Определяем, какой загрузчик сейчас видим, а какой будет следующим
        root._fromLoader = root._showExpanded ? expandedLoader : collapsedLoader;
        root._toLoader = root._showExpanded ? collapsedLoader : expandedLoader;
        // Скрываем целевой загрузчик (будет показан через fadeIn)
        root._toLoader.opacity = 0;

        // Запускаем исчезновение текущего
        fadeOut.target = root._fromLoader;
        fadeOut.restart();
    }

    onExpandedChanged: _sync()

    Component.onCompleted: {
        root._showExpanded = root.expanded;
        root._queuedExpanded = root.expanded;
        // Устанавливаем начальную прозрачность
        collapsedLoader.opacity = root.expanded ? 0 : 1;
        expandedLoader.opacity = root.expanded ? 1 : 0;
    }
}
