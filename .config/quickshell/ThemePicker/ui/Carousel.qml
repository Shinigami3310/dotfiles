import QtQuick
import "../shared/theme"
import "../theme"

Item {
    id: root

    property list<string> model: []
    property int currentIndex: 0
    property real cardHeight: 0
    property real cardWidth: 0
    property real spacing: 0
    property real bevel: 0

    property real offset: currentIndex

    property int _visibleCount: 1

    Behavior on offset {
        NumberAnimation {
            duration: Motion.durationExpand
            easing.type: Motion.curveContinuous
        }
    }

    Repeater {
        model: root.model

        delegate: Item {
            id: card

            readonly property real distance: Math.abs(index - root.offset)
            readonly property real scale: 1 + Math.max(0, 1 - distance) * (Configs.centerScaleFactor - 1)

            width: root.cardWidth * scale
            height: root.cardHeight * scale
            x: (root.width - width) / 2 + (index - root.offset) * root.spacing
            y: (root.height - height) / 2

            WallpaperCard {
                anchors.fill: parent
                source: Configs.wallpaperDir + "/" + modelData
                bevel: root.bevel * card.scale
                loadRequested: index < root._visibleCount

                onLoaded: if (index === root._visibleCount - 1) root._visibleCount++
            }
        }
    }
}
