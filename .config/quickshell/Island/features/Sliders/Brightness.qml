import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations" // Укажите правильный путь к папке, где лежит BrightnessService.qml

Item {
    id: root

    property bool active: true
    signal closeRequested

    implicitWidth: slider.implicitWidth + Configs.osdPaddingX
    implicitHeight: slider.implicitHeight + Configs.osdPaddingY

    Timer {
        id: idleTimer
        interval: Configs.osdIdleTimeout
        running: root.active
        repeat: false
        onTriggered: root.closeRequested()
    }

    function bumpIdle() {
        if (root.active)
            idleTimer.restart();
    }

    onActiveChanged: {
        if (root.active)
            bumpIdle();
    }

    // Подключаемся к глобальному синглтону
    Connections {
        target: BrightnessService

        function onLevelChanged() {
            root.bumpIdle();
        }
    }

    Slider {
        id: slider
        anchors.centerIn: parent

        // Используем данные из синглтона напрямую
        value: BrightnessService.level
        fillColor: Theme.accent
        iconSource: Qt.resolvedUrl("../../assets/icons/Brightness.png")
        interactiveIcon: true

        onRequestValueChange: function (requestedValue) {
            BrightnessService.setLevel(requestedValue);
        }

        onInteracted: root.bumpIdle()
    }
}
