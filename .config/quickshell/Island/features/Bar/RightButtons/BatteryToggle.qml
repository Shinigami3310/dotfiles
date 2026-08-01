import QtQuick

Icon {
    source: "../../../assets/icons/Battery.png"
    signal surfaceRequested(string newName)
    onClicked: {
        active: true;
        surfaceRequested("batteryProfile");
    }
}
