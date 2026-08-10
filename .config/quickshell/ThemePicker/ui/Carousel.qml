import QtQuick
import "../theme"

// Wallpaper carousel. Uses a floating (fractional) offset instead of a discrete
// currentIndex: this gives continuous animation without a Behavior on each card
// and without manual timer management in the UI.
Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property real cardHeight: 0
    property real cardWidth: 0
    property real spacing: 0
    property real bevel: 0

    // Floating index: when currentIndex changes, offset interpolates smoothly
    // and all cards are recomputed continuously.
    property real offset: currentIndex

    // Index of the next card to unlock for loading. Only card 0 loads first;
    // each next card loads only after the previous one is ready, so disk/CPU
    // work is staggered instead of fetching every image simultaneously.
    property int _nextToLoad: 1

    Behavior on offset {
        NumberAnimation {
            duration: Motion.standard
            easing.type: Motion.easeOut
        }
    }

    Repeater {
        model: root.model

        delegate: Item {
            id: card

            // Fractional distance to center: 0 = center, 1 = neighbor.
            // Intermediate values give a smooth transition.
            property real distance: Math.abs(index - root.offset)

            // Continuous scale: 1.5 at center, 1.0 at neighbors.
            // Linear interpolation between them.
            property real currentScaleFactor: 1.0 + Math.max(0, 1 - distance) * (Configs.centerScaleFactor - 1.0)

            // Size and position computed directly (no Behavior),
            // because offset is already animated — double animation is not needed.
            width: root.cardWidth * currentScaleFactor
            height: root.cardHeight * currentScaleFactor

            x: (root.width - width) / 2 + (index - root.offset) * root.spacing
            y: (root.height - height) / 2

            // Cards closer to center are higher. Multiply by the step to
            // avoid conflicts at very close distance values.
            z: Configs.zBase - Math.round(distance * Configs.zStep)

            WallpaperCard {
                anchors.fill: parent
                source: "file://" + Configs.wallpaperDir + "/" + modelData
                bevel: root.bevel * card.currentScaleFactor
                // Only the current card loads; the next is unlocked when this one is ready.
                loadRequested: index < root._nextToLoad

                onLoaded: {
                    // When the last currently-unlocked card is ready, unlock
                    // the next one, keeping loads sequential.
                    if (index === root._nextToLoad - 1)
                        root._nextToLoad++;
                }
            }
        }
    }
}
