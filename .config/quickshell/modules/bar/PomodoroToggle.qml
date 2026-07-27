import QtQuick

Icon {
    source: "../../assets/icons/pomodoro.png"

    signal toggled(bool active)

    function toggle() {
        active = !active;
        toggled(active);
    }

    onClicked: toggle()
}
