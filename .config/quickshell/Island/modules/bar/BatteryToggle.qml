import QtQuick

Icon {
    source: "../../assets/icons/battery.png"

    signal surfaceRequested(string newName, var payload)

    onClicked: surfaceRequested("battery-profile", null)
}
