import QtQuick
import "../../theme"
import "../../core"

Item {
    id: root

    signal surfaceRequested(string name)

    // Полоска в fullscreen-режиме — минимальный «якорь» для возврата
    // к HomeClock. Размер 60×12 — это граница клика, а не визуальный элемент.
    implicitWidth: 60
    implicitHeight: 12

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested(SurfaceNames.homeClock)
    }
}
