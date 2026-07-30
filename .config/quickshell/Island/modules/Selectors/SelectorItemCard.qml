import QtQuick
import "../../Singletons/"

Rectangle {
    id: root

    property string name: "Unknown"
    property string security: "" // Если пусто или "--", сеть без пароля
    property bool isConnected: false
    property bool isConnecting: false

    // Внутреннее состояние: вводим ли мы пароль прямо сейчас
    property bool isInputting: false

    signal connectRequested(string password)

    width: parent?.width ?? 0    // Карточка увеличивается, если нужно ввести пароль
    height: isInputting ? 88 : 48
    radius: 12
    color: isConnected ? Theme.accent : Theme.surface1
    border.color: mouseArea.containsMouse && !isConnected ? Theme.accentSoft : "transparent"
    border.width: 1
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutQuart
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 8
        width: parent.width - 24

        // Название сети / статус
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.isConnecting ? "Подключение..." : root.name
            font.family: Theme.font
            font.pixelSize: 13
            color: root.isConnected ? Theme.accentText : Theme.text
            opacity: root.isConnecting ? pulseAnim.opacityValue : 1.0

            NumberAnimation on opacity {
                id: pulseAnim
                property real opacityValue: 1.0
                from: 1.0
                to: 0.4
                duration: 600
                loops: Animation.Infinite
                running: root.isConnecting
                easing.type: Easing.InOutSine
            }
        }

        // Поле ввода пароля (появляется только если isInputting = true)
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 28
            radius: 6
            color: Theme.surface2
            visible: root.isInputting
            border.color: pwdInput.activeFocus ? Theme.accent : "transparent"

            TextInput {
                id: pwdInput
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.text
                font.pixelSize: 13
                echoMode: TextInput.Password
                passwordCharacter: "•"

                // При нажатии Enter отправляем пароль
                onAccepted: {
                    root.isInputting = false;
                    root.connectRequested(pwdInput.text);
                    pwdInput.text = ""; // очищаем после отправки
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (root.isConnected || root.isConnecting)
                return;

            // Если пароль нужен и мы еще его не вводим - открываем поле
            if (root.security !== "" && root.security !== "--" && !root.isInputting) {
                root.isInputting = true;
                pwdInput.forceActiveFocus();
            } else if (!root.isInputting) {
                // Если сеть открытая - подключаемся без пароля
                root.connectRequested("");
            }
        }
    }
}
