import QtQuick
import "../theme"

Item {
    id: root

    property var model: []
    property int currentIndex: 0
    property real cardHeight: 0
    property real cardWidth: 0
    property real spacing: 0
    property real bevel: 0

    // 1. ЕДИНСТВЕННАЯ АНИМАЦИЯ: Плавающий (дробный) индекс.
    // Когда currentIndex становится 1, offset плавно ползет 0.0 -> 0.1 -> ... -> 1.0
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

            // 2. Расстояние теперь дробное.
            // Например, на середине анимации distance может быть 0.5
            property real distance: Math.abs(index - root.offset)

            // 3. Непрерывная функция масштаба.
            // Если distance = 0 (центр), множитель = Configs.scaleCenter (1.5)
            // Если distance >= 1 (соседи), множитель = 1.0
            // Значения между ними интерполируются плавно!
            property real currentScaleFactor: 1.0 + Math.max(0, 1 - distance) * (Configs.scaleCenter - 1.0)

            // 4. Размеры жестко привязаны к множителю (БЕЗ Behavior)
            width: root.cardWidth * currentScaleFactor
            height: root.cardHeight * currentScaleFactor

            // 5. Координаты зависят от ПЛАВАЮЩЕГО offset (БЕЗ Behavior)
            x: (root.width - width) / 2 + (index - root.offset) * root.spacing
            y: (root.height - height) / 2

            // 6. Z-индекс. Карточка, которая ближе к центру, всегда выше.
            // Умножаем на 10, чтобы избежать конфликтов при очень близких значениях.
            z: 100 - Math.round(distance * 10)

            WallpaperCard {
                anchors.fill: parent
                source: "file:///home/Rostislav/Pictures/Wallpapers/" + modelData
                bevel: root.bevel * card.currentScaleFactor
            }
        }
    }
}
