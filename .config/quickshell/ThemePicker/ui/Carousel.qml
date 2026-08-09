import QtQuick
import "../theme"

// Карусель обоев. Использует плавающий (дробный) offset вместо дискретного
// currentIndex: это даёт непрерывную анимацию без Behavior на каждой карточке
// и без ручного управления таймерами в UI.
Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property real cardHeight: 0
    property real cardWidth: 0
    property real spacing: 0
    property real bevel: 0

    // Плавающий индекс: когда currentIndex меняется, offset плавно
    // интерполируется, и все карточки пересчитываются непрерывно.
    property real offset: currentIndex

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

            // Дробное расстояние до центра: 0 = центр, 1 = сосед.
            // Промежуточные значения дают плавный переход.
            property real distance: Math.abs(index - root.offset)

            // Непрерывный масштаб: 1.5 в центре, 1.0 у соседей.
            // Линейная интерполяция между ними.
            property real currentScaleFactor: 1.0 + Math.max(0, 1 - distance) * (Configs.scaleCenter - 1.0)

            // Размеры и позиция вычисляются напрямую (без Behavior),
            // потому что offset уже анимируется — двойная анимация не нужна.
            width: root.cardWidth * currentScaleFactor
            height: root.cardHeight * currentScaleFactor

            x: (root.width - width) / 2 + (index - root.offset) * root.spacing
            y: (root.height - height) / 2

            // Карточка ближе к центру — выше. Умножаем на шаг, чтобы
            // избежать конфликтов при очень близких значениях distance.
            z: Configs.zBase - Math.round(distance * Configs.zStep)

            WallpaperCard {
                anchors.fill: parent
                source: "file://" + Configs.wallpaperDir + "/" + modelData
                bevel: root.bevel * card.currentScaleFactor
            }
        }
    }
}
