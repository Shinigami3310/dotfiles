import QtQuick

// Удерживает синглтон-сервис «в awake» на время жизни компонента.
// Заменяет дублирующийся паттерн:
//   Component.onCompleted: XService.retain()
//   Component.onDestruction: XService.release()
Item {
    required property QtObject service

    Component.onCompleted: service.retain()
    Component.onDestruction: service.release()
}