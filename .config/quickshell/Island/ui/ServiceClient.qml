import QtQuick

Item {
    required property QtObject service

    Component.onCompleted: service.retain()
    Component.onDestruction: service.release()
}
