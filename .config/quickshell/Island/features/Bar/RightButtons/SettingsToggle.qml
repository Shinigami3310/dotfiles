import QtQuick

Icon {
    source: "../../../assets/icons/Settings.png"
    signal surfaceRequested(string newName)
    onClicked: surfaceRequested("controlPanel")
}
