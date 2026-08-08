import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    property real bevel: 20
    property alias source: image.source

    Shape {
        id: maskShape
        anchors.fill: parent
        visible: false

        layer.enabled: true
        layer.smooth: true
        layer.samples: 4
        preferredRendererType: Shape.CurveRenderer

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
        smooth: true
        mipmap: true
    }

    MultiEffect {
        anchors.fill: parent
        source: image
        maskEnabled: true
        maskSource: maskShape
    }
}
