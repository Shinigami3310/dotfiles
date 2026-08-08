import QtQuick

FocusScope {
    id: root

    property string surfaceName: ""
    property bool active: false
    property bool canGoBack: true

    signal surfaceRequested(string name)
    signal backRequested
    signal closeRequested

    // Только активная поверхность с навигацией назад получает клавиатуру.
    // Без этого OSD (brightnessSlider) перехватывал бы Esc, хотя закрывать
    // его должен клик мимо, а не клавиша.
    readonly property bool requiresKeyboard: active && canGoBack

    focus: requiresKeyboard
    Keys.enabled: requiresKeyboard

    Keys.onEscapePressed: event => {
        if (canGoBack) {
            closeRequested();
            event.accepted = true;
        }
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: if (canGoBack)
            backRequested()
    }

    function enter() {
        active = true;
    }
    function exit(nextSurfaceName: string) {
        active = false;
    }
}
