import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    smooth: true

    property real bevel: 20
    property alias source: image.source

    // Размер текстуры с запасом для центральной (увеличенной) карточки.
    // Вычисляем от фактического размера, чтобы адаптироваться к DPI и размерам.
    readonly property real _effectiveSourceWidth: Math.ceil(Math.max(width * Screen.devicePixelRatio * 1.5, 1))

    Shape {
        id: maskShape
        anchors.fill: parent
        visible: false

        layer.enabled: true
        layer.smooth: true

        // Включаем геометрию и сглаживание для идеальных краев
        preferredRendererType: Shape.GeometryRenderer
        antialiasing: true

        // ShapePath автоматически пересчитает кривые пиксель-в-пиксель,
        // так как width и height родителя теперь плавно анимируются.
        ShapePath {
            fillColor: "black"
            strokeWidth: 0

            startX: Math.min(root.bevel, root.height)
            startY: 0

            PathLine {
                x: root.width
                y: 0
            }
            PathLine {
                x: root.width - Math.min(root.bevel, root.height)
                y: root.height
            }
            PathLine {
                x: 0
                y: root.height
            }
            PathLine {
                x: Math.min(root.bevel, root.height)
                y: 0
            }
        }
    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        visible: false
        asynchronous: true

        // Размер текстуры загружаем с запасом для центральной (увеличенной) карточки
        sourceSize.width: root._effectiveSourceWidth

        // Включаем генерацию mipmaps для плавного качества при любых размерах
        mipmap: true
    }

    MultiEffect {
        anchors.fill: parent
        source: image
        maskEnabled: true
        maskSource: maskShape
    }
}
