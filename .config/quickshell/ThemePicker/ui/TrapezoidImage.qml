import QtQuick 6.0
import qs.config           // Theme.*

// Один элемент карусели: картинка → маска трапеции (ShaderEffect) → scale‑анимация.
Item {
    id: root
    property string source: ""      // путь к файлу (ставится WallpaperCarousel)
    property real targetScale: 1.0
    property bool selected: false
    transformOrigin: Item.Center

    // scale декларативно следует targetScale; анимируем TRANSITION через Behavior —
    // без setter‑логики в биндингах (правило §3).
    scale: targetScale
    Behavior on scale { NumberAnimation { duration: Theme.scaleDurationMs; easing.type: Easing.OutCubic } }

    property real topInset: Theme.trapezoidInset   // в шейдер → uniform float topInset

    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.source
        asynchronous: true                 // Qt‑декодер в потоке — нет фризов
        cache: true
        fillMode: Image.PreserveAspectCrop
        visible: false                      // рендерится эффектом, а не в сцене
        z: 1
    }

    ShaderEffect {
        anchors.fill: parent
        // Qt6 ShaderEffect не имеет встроенного `source` (как в Qt5): объявляем алиас —
        // Image рендерится в текстуру → привязывается к `uniform sampler2D source`.
        property alias source: wallpaper
        property real topInset: root.topInset   // → uniform float topInset
        fragmentShader: "shaders/trapezoidClip.frag"
        z: 2
    }

    // Обводка выбранной трапеции (цвет/толщина из конфига — без хардкода).
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.highlightColor
        border.width: root.selected ? Theme.highlightWidth : 0
        z: 3
    }

    // Плейсхолдер, пока async‑Image не готова (нет белого мигания / фриза).
    Rectangle {
        anchors.fill: parent
        color: Theme.imagePlaceholderColor
        z: 0
        visible: wallpaper.status !== Image.Ready
    }
}
