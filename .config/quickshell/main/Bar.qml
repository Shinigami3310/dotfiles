import Quickshell
import QtQuick

Item {
    id: bar

    Rectangle {
        id: rec
        color: "white"
        implicitWidth: 400
        implicitHeight: 100
    }

    implicitWidth: rec.implicitWidth
    implicitHeight: rec.implicitHeight
}
