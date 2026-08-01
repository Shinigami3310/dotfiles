import QtQuick
import "../../../services/integrations/"

Icon {
    source: "../../../assets/icons/Eye.png"
    active: EyeReminderService.isLoaded
    onClicked: EyeReminderService.toggle()
}
