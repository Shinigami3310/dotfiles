import QtQuick
import "../Singletons"

Item {
    id: root

    property bool expanded: false
    property Component collapsedComponent
    property Component expandedComponent

    property int paddingX: 20
    property int paddingY: 10
    property int fadeDuration: Motion.fade

    property bool _showExpanded: false
    property bool _queuedExpanded: false
    property bool _busy: false

    property Item _fromLoader: null
    property Item _toLoader: null

    property int minCollapsedWidth: 120

    readonly property int maxExpandedHeight: 500
    readonly property int maxExpandedWidth: 500

    readonly property int collapsedWidth: collapsedLoader.item ? Math.ceil(collapsedLoader.item.implicitWidth + paddingX * 2) : 0, minCollapsedWidth
    readonly property int collapsedHeight: collapsedLoader.item ? Math.ceil(collapsedLoader.item.implicitHeight + paddingY * 2) : 0

    readonly property int expandedWidth: expandedLoader.item ? Math.ceil(expandedLoader.item.implicitWidth + paddingX * 2) : 0
    readonly property int expandedHeight: expandedLoader.item ? Math.ceil(expandedLoader.item.implicitHeight + paddingY * 2) : 0

    readonly property int reservedWidth: Math.max(collapsedWidth, expandedWidth)
    readonly property int reservedHeight: Math.max(collapsedHeight, expandedHeight)

    readonly property int currentWidth: _showExpanded ? expandedWidth : collapsedWidth
    readonly property int currentHeight: _showExpanded ? expandedHeight : collapsedHeight

    implicitWidth: currentWidth
    implicitHeight: currentHeight

    Loader {
        id: collapsedLoader
        anchors.centerIn: parent
        sourceComponent: root.collapsedComponent
        visible: opacity > 0
        // opacity управляется через анимации
    }

    Loader {
        id: expandedLoader
        anchors.centerIn: parent
        sourceComponent: root.expandedComponent
        visible: opacity > 0
        // opacity управляется через анимации
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
