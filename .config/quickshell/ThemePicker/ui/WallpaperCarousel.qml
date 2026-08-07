import QtQuick 6.0
import qs.config           // Theme.*
import qs.services         // ThemeModel, HyprlandMonitor

// Горизонтальная карусель: ФИКС. пул из Theme.visiblePoolSize элементов (без
// create/destroy при навигации — правило §3). Реакция на сигнатуры модели.
Item {
    id: root
    width: parent.width
    height: itemHeight
    anchors.centerIn: parent

    readonly property real itemHeight: HyprlandMonitor.screenHeight * Theme.imageHeightRatio
    readonly property real itemWidth: itemHeight * Theme.imageAspectRatio
    readonly property real poolWidth: Theme.visiblePoolSize * itemWidth
                                + (Theme.visiblePoolSize - 1) * Theme.carouselGap

    function scaleForOffset(offset) {
        if (offset === 0) return Theme.centerScale;
        return Math.abs(offset) === 1 ? Theme.nearScale : Theme.sideScale;
    }

    function refresh() {
        var n = pool.count;
        var center = Math.floor(n / 2);
        for (var i = 0; i < n; ++i) {
            var off = i - center;
            var item = pool.itemAt(i);
            item.source = ThemeModel.pathAt(ThemeModel.currentIndex + off);
            item.selected = (off === 0);
            item.targetScale = scaleForOffset(off);
        }
    }

    Row {
        id: row
        spacing: Theme.carouselGap
        anchors.centerIn: parent
        transformOrigin: Item.Center        // масштабируем ряд по центру, а не от левого‑верхнего
        scale: root.poolWidth > 0
             ? Math.min(1, (root.width - 2 * Theme.carouselPadding) / root.poolWidth)
             : 1
    }

    // Фикс. пул. Делегатуник привязывает размеры к root.itemWidth/Height.
    Repeater {
        id: pool
        parent: row
        model: Theme.visiblePoolSize
        delegate: TrapezoidImage { width: root.itemWidth; height: root.itemHeight }
    }

    NavButton { direction: "left";  anchors.left: parent.left;   anchors.leftMargin: Theme.carouselPadding; anchors.verticalCenter: parent.verticalCenter; onActivated: ThemeModel.move(-1) }
    NavButton { direction: "right"; anchors.right: parent.right; anchors.rightMargin: Theme.carouselPadding; anchors.verticalCenter: parent.verticalCenter; onActivated: ThemeModel.move(+1) }

    // Реакция на сигнатуры модели через Connections — НЕ onValueChanged (правило §3).
    Connections {
        target: ThemeModel
        onCurrentIndexChanged: refresh()
        onPathsChanged: refresh()
    }
    Component.onCompleted: refresh()
}
