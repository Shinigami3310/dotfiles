import QtQuick 6.0
import qs.config           // Theme.navButtonSize / highlightColor

// Переиспользуемая стрелка навигации (left/right). Излучает сигнал activated —
// реакция на событие, а не onValueChanged (правило .clinerules §3).
Item {
    id: root
    property string direction: "left"          // "left" | "right"
    width: Theme.navButtonSize
    height: Theme.navButtonSize
    signal activated()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }

    // Глиф ‹ / ›. Цвет/размер — из конфига, без магических чисел.
    Text {
        anchors.centerIn: parent
        text: root.direction === "left" ? "\u2039" : "\u203A"
        font.pixelSize: Math.round(root.height * 0.55)
        color: Theme.highlightColor
        opacity: mouseArea.pressed ? 0.6 : 1.0
    }
}
