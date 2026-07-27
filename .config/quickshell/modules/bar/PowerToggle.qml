import QtQuick

Icon {
    source: "../../assets/icons/power.png"

    signal powerRequested

    onClicked: powerRequested()
}
