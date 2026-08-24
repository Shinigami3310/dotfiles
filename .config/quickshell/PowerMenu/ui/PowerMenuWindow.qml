import QtQuick

Item {
    id: root
    focus: true

    signal closeRequested
    signal actionRequested(var command)

    Rectangle {
        anchors.fill: parent
        color: "#66000000"
    }

    readonly property var actions: [
        { label: "Reboot",    source: "../icons/Reboot.png",    command: ["systemctl", "reboot"] },
        { label: "Suspend",   source: "../icons/Suspend.png",   command: ["systemctl", "suspend"] },
        { label: "Power Off", source: "../icons/Power.png",     command: ["systemctl", "poweroff"] },
        { label: "Hibernate", source: "../icons/Hibernate.png", command: ["systemctl", "hibernate"] },
        { label: "Lock",      source: "../icons/Lock.png",      command: ["hyprlock"] }
    ]

    property int lastIndex: 2

    Component.onCompleted: buttonsRepeater.itemAt(2).forceActiveFocus()

    function moveFocus(step) {
        const count = buttonsRepeater.count
        for (let i = 0; i < count; i++) {
            if (buttonsRepeater.itemAt(i).activeFocus) {
                buttonsRepeater.itemAt(Math.max(0, Math.min(count - 1, i + step))).forceActiveFocus()
                return
            }
        }
        buttonsRepeater.itemAt(lastIndex).forceActiveFocus()
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) closeRequested()
        if (event.key === Qt.Key_Right) moveFocus(1)
        if (event.key === Qt.Key_Left) moveFocus(-1)
    }

    Row {
        anchors.centerIn: parent

        Repeater {
            id: buttonsRepeater
            model: actions

            delegate: ActionButton {
                required property var modelData
                required property int index

                source: modelData.source
                label: modelData.label

                onActiveFocusChanged: if (activeFocus) root.lastIndex = index
                onActivated: root.actionRequested(modelData.command)
            }
        }
    }
}
