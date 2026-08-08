import QtQuick
import "../theme"

// Карусель: центральная карточка крупнее, соседние меньше, остальные ещё меньше.
// Позиция и масштаб считаются простыми арифметическими биндингами (без тяжёлых
// функций в биндингах) и анимируются через Behavior.
Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property real cardHeight: 0
    property real cardWidth: 0
    property real spacing: 0
    property real bevel: 0

    // Масштаб по удалённости от центра: 0 → scaleCenter, 1 → scaleNear, ≥2 → scaleFar
    function scaleFor(distance) {
        if (distance === 0)
            return Configs.scaleCenter;
        if (distance === 1)
            return Configs.scaleNear;
        return Configs.scaleFar;
    }

    Repeater {
        model: root.model

        delegate: Item {
            id: card
            width: root.cardWidth
            height: root.cardHeight

            // Позиция по горизонтали: центр + смещение от текущего индекса
            property int distance: Math.abs(index - root.currentIndex)
            x: (root.width - width) / 2 + (index - root.currentIndex) * root.spacing
            scale: root.scaleFor(distance)

            Behavior on x {
                NumberAnimation {
                    duration: Motion.standard
                    easing.type: Motion.easeOut
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Motion.standard
                    easing.type: Motion.easeOut
                }
            }

            WallpaperCard {
                anchors.fill: parent
                source: "file:///home/Rostislav/Pictures/Wallpapers/" + modelData
                bevel: root.bevel
            }
        }
    }
}
