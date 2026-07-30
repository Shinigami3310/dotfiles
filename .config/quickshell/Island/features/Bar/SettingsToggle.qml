import QtQuick

Icon {
    source: "../../assets/icons/settings.png"

    signal surfaceRequested(string newName)

    onClicked: surfaceRequested("controlPanel")
}
