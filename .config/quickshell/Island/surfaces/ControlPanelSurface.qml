import QtQuick
import "../core"
import "../features/ControlPanel"

SurfaceBase {
    id: root
    surfaceName: "controlPanel"

    implicitWidth: controlPanel.implicitWidth
    implicitHeight: controlPanel.implicitHeight

    ControlPanel {
        id: controlPanel
        anchors.centerIn: parent
        // Передаем newName из сигнала модуля в сигнал поверхности
        onSurfaceRequested: newName => root.surfaceRequested(newName)
    }
}
