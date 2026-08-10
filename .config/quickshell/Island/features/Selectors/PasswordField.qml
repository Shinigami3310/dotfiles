import QtQuick
import "../../shared/theme"

// Поле ввода пароля. Автофокус при появлении обязателен: иначе пользователь
// начнёт печатать, а символы уйдут в никуда (фокус ещё на списке).
// Потеря фокуса с пустым полем = отмена — это дешевле, чем кнопка «отмена».
Rectangle {
    id: root

    property bool active: false
    signal submitted(string password)

    width: parent?.width ?? 0
    height: SelectorConfig.inputContainerHeight
    radius: SelectorConfig.inputRadius
    color: ThemeColor.surface_container_highest
    visible: root.active
    opacity: root.active ? 1.0 : 0.0
    border.color: pwdInput.activeFocus ? ThemeColor.primary : ThemeColor.transparent
    border.width: 1

    Behavior on opacity {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: Motion.fast
        }
    }

    TextInput {
        id: pwdInput
        anchors.fill: parent
        anchors.margins: SelectorConfig.inputPadding
        verticalAlignment: TextInput.AlignVCenter
        color: ThemeColor.on_surface
        font.pixelSize: SelectorConfig.cardTextSize
        echoMode: TextInput.Password
        passwordCharacter: "•"

        onActiveFocusChanged: {
            if (!activeFocus && root.active && text === "") {
                root.active = false;
            }
        }

        onAccepted: {
            if (text.trim() !== "") {
                root.active = false;
                root.submitted(text);
                text = "";
            }
        }
    }

    onActiveChanged: {
        if (root.active)
            pwdInput.forceActiveFocus();
    }
}