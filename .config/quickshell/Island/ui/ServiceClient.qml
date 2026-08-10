import QtQuick

// Удерживает синглтон-сервис «в awake», пока компонент жив. Без этого
// ресурсоёмкие сервисы (Battery/SystemStats) продолжали бы опрашивать
// систему даже когда их UI закрыт — это разряжает батарею впустую.
Item {
    required property QtObject service

    Component.onCompleted: service.retain()
    Component.onDestruction: service.release()
}