import QtQuick
import "../../shared/theme"

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
            duration: Motion.durationFast
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: Motion.durationFast
        }
    }

    TextInput {
        id: pwdInput
        // Высота = весь контейнер: при узких отступах строка шрифта (~15px)
        // была выше бокса TextInput (12px), и центрирование ломалось — курсор
        // уезжал вверх. Растягиваем по вертикали и центрируем внутри полной
        // высоты, по горизонтали ограничиваем только паддингами.
        anchors {
            fill: parent
            leftMargin: SelectorConfig.inputPadding
            rightMargin: SelectorConfig.inputPadding
        }
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignHCenter
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
