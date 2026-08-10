import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Window // Imported for Screen

Item {
    id: root
    smooth: true

    property real bevel: 20
    // Image source. Applied to the Image only when loadRequested becomes true,
    // so the carousel can stagger loading instead of fetching all at once.
    property string source: ""
    // When true, the image starts loading. Set by the carousel to sequence loads.
    property bool loadRequested: false
    // Emitted once the image has finished loading.
    signal loaded()
    // Texture size is tied to the screen (with DPI), not to the card:
    // computed once and not reset on every carousel animation frame.
    readonly property real _effectiveSourceWidth: Math.ceil(Math.max(Screen.width * Screen.devicePixelRatio, 1))

    Shape {
        id: maskShape
        anchors.fill: parent
        visible: false

        layer.enabled: true
        layer.smooth: true

        // Geometry is recomputed every frame for perfect vector sharpness
        preferredRendererType: Shape.GeometryRenderer
        antialiasing: true

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

        // Only load when the carousel requests it, to stagger disk/CPU work.
        source: root.loadRequested ? root.source : ""
        // Size tied to the screen, not to the card
        sourceSize.width: root._effectiveSourceWidth

        mipmap: true

        onStatusChanged: {
            // Emit on Ready AND Error so a broken file does not block
            // the sequential loading chain in the carousel.
            if (status === Image.Ready || status === Image.Error)
                root.loaded();
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: image
        maskEnabled: true
        maskSource: maskShape
    }
}