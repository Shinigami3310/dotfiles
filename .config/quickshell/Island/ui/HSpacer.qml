import QtQuick
import QtQuick.Layouts

// Горизонтальная распорка: занимает всё свободное место в RowLayout.
// Заменяет повторяющиеся `Item { Layout.fillWidth: true }`.
Item {
    Layout.fillWidth: true
}