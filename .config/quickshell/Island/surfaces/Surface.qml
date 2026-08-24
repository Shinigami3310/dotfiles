import QtQuick
import "../core"

SurfaceBase {
    id: root

    required property Component feature

    implicitWidth: loader.item ? loader.item.implicitWidth : 0
    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    Loader {
        id: loader
        sourceComponent: root.feature
    }

    Connections {
        target: loader.item
        ignoreUnknownSignals: true
        function onSurfaceRequested(name) { root.surfaceRequested(name) }
        function onCloseRequested() { root.closeRequested() }
        function onBackRequested() { root.backRequested() }
    }
}
