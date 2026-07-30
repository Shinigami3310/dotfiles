import QtQuick

Icon {
    source: "../../assets/icons/battery.png"

    signal surfaceRequested(string newName)

    onClicked: surfaceRequested("battery")
}
