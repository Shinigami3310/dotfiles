import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Window

Item {
    id: root

    property real bevel: 20
    property string source: ""
    property bool loadRequested: false

    signal loaded()

    Shape {
        id: maskShape
        anchors.fill: parent
        visible: false
        layer.enabled: true

        ShapePath {
            PathLine { x: width; y: 0 }
            PathLine { x: width - root.bevel; y: height }
            PathLine { x: 0; y: height }
            PathLine { x: root.bevel; y: 0 }
        }
    }

    Image {
        id: image
        anchors.fill: parent
        visible: false
        asynchronous: true

        source: root.loadRequested ? root.source : ""
        sourceSize.width: Screen.width * Screen.devicePixelRatio

        mipmap: true

        onStatusChanged: {
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
